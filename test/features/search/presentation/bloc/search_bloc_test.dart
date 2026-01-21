import 'package:bloc_test/bloc_test.dart';
import 'package:ecommerce_app/features/search/domain/entities/search_result.dart';
import 'package:ecommerce_app/features/search/domain/usecases/search_products.dart';
import 'package:ecommerce_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchProducts extends Mock implements SearchProducts {}

void main() {
  late SearchBloc searchBloc;
  late MockSearchProducts mockSearchProducts;

  setUp(() {
    mockSearchProducts = MockSearchProducts();
    searchBloc = SearchBloc(mockSearchProducts);
  });

  tearDown(() {
    searchBloc.close();
  });

  const tQuery = 'iphone';
  const tSearchResult = SearchResult(
    id: '1',
    name: 'iPhone 9',
    brand: 'Apple',
    price: 549,
    imageUrl: 'https://i.dummyjson.com/data/products/1/thumbnail.jpg',
    rating: 4.69,
    reviews: 94,
  );
  final tSearchResultList = [tSearchResult];

  test('initial state should be SearchInitial', () {
    expect(searchBloc.state, equals(SearchInitial()));
  });

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoading, SearchLoaded] when data is gotten successfully',
    build: () {
      when(() => mockSearchProducts(any()))
          .thenAnswer((_) async => tSearchResultList);
      return searchBloc;
    },
    act: (bloc) => bloc.add(const SearchQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchLoaded(tSearchResultList),
    ],
    verify: (_) {
      verify(() => mockSearchProducts(tQuery)).called(1);
    },
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoading, SearchEmpty] when data is empty',
    build: () {
      when(() => mockSearchProducts(any())).thenAnswer((_) async => []);
      return searchBloc;
    },
    act: (bloc) => bloc.add(const SearchQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchEmpty(),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoading, SearchError] when getting data fails',
    build: () {
      when(() => mockSearchProducts(any())).thenThrow(Exception('Error'));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const SearchQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchError('Exception: Error'),
    ],
  );
}
