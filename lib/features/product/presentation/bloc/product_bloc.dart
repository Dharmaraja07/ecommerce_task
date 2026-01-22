import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';


part 'product_event.dart';
part 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<LoadProductDetails>(_onLoadProductDetails);
  }

  Future<void> _onLoadProductDetails(LoadProductDetails event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final product = await repository.getProductDetails(event.id);
      final related = await repository.getRelatedProducts(event.id); // Returns List<ProductEntity> now
      emit(ProductLoaded(product, related));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
