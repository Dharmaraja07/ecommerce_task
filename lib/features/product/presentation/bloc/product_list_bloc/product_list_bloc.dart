import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

const _throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

@injectable
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepository repository;

  ProductListBloc(this.repository) : super(const ProductListState()) {
    on<ProductListStarted>(_onStarted);
    on<ProductListScrolled>(
      _onScrolled,
      transformer: throttleDroppable(_throttleDuration),
    );
    on<ProductListSearched>(_onSearched);
  }

  Future<void> _onStarted(ProductListStarted event, Emitter<ProductListState> emit) async {
    if (state.hasReachedMax && state.products.isNotEmpty && state.searchQuery == null) return;
    
    emit(state.copyWith(status: ProductListStatus.loading));
    
    try {
      final products = await repository.getProducts(page: 1, limit: 10);
      return emit(state.copyWith(
        status: ProductListStatus.success,
        products: products,
        hasReachedMax: products.length < 10,
        currentPage: 1,
      ));
    } catch (_) {
      emit(state.copyWith(status: ProductListStatus.failure));
    }
  }

  Future<void> _onScrolled(ProductListScrolled event, Emitter<ProductListState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == ProductListStatus.failure) return; // Optional: retry logic?

    try {
      final nextPage = state.currentPage + 1;
      final products = await repository.getProducts(
        page: nextPage, 
        limit: 10,
        search: state.searchQuery,
      );
      
      if (products.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
          status: ProductListStatus.success,
          products: List.of(state.products)..addAll(products),
          hasReachedMax: products.length < 10,
          currentPage: nextPage,
        ));
      }
    } catch (_) {
      emit(state.copyWith(status: ProductListStatus.failure));
    }
  }

  Future<void> _onSearched(ProductListSearched event, Emitter<ProductListState> emit) async {
    emit(state.copyWith(
      status: ProductListStatus.loading,
      searchQuery: event.query,
      products: [],
      hasReachedMax: false,
      currentPage: 0, // Will become 1 in fetch
    ));

    try {
      final products = await repository.getProducts(page: 1, limit: 10, search: event.query);
      emit(state.copyWith(
        status: ProductListStatus.success,
        products: products,
        hasReachedMax: products.length < 10,
        currentPage: 1,
      ));
    } catch (_) {
      emit(state.copyWith(status: ProductListStatus.failure));
    }
  }
}
