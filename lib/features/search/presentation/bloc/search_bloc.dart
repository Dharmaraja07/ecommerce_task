import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/features/search/domain/entities/search_result.dart';
import 'package:ecommerce_app/features/search/domain/usecases/search_products.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProducts searchProducts;

  SearchBloc(this.searchProducts) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  Future<void> _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    final query = event.query;
    if (query.isEmpty) {
      emit(SearchInitial()); // Or load trending
      return;
    }

    emit(SearchLoading());

    try {
      final results = await searchProducts(query);
      if (results.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(results));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
