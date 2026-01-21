import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:ecommerce_app/features/search/domain/entities/search_result.dart';
import 'package:ecommerce_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:ecommerce_app/features/search/presentation/pages/search_page.dart';
import 'package:ecommerce_app/features/search/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class MockHttpClient extends Mock implements HttpClient {}
class MockHttpClientRequest extends Mock implements HttpClientRequest {}
class MockHttpClientResponse extends Mock implements HttpClientResponse {}
class MockHttpHeaders extends Mock implements HttpHeaders {}

void main() {
  late MockSearchBloc mockSearchBloc;

  setUpAll(() {
    registerFallbackValue(SearchInitial());
    registerFallbackValue(const SearchQueryChanged(''));
  });

  setUp(() {
    mockSearchBloc = MockSearchBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<SearchBloc>.value(
        value: mockSearchBloc,
        child: const SearchView(),
      ),
    );
  }

  group('SearchPage', () {
    testWidgets('renders initial state', (tester) async {
      when(() => mockSearchBloc.state).thenReturn(SearchInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Search for "lipstick", "serum"...'), findsOneWidget);
    });

    testWidgets('renders loading state', (tester) async {
      when(() => mockSearchBloc.state).thenReturn(SearchLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders empty state', (tester) async {
      when(() => mockSearchBloc.state).thenReturn(SearchEmpty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No results found.'), findsOneWidget);
    });

    testWidgets('renders error state', (tester) async {
      const errorMessage = 'Something went wrong';
      when(() => mockSearchBloc.state).thenReturn(const SearchError(errorMessage));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Error: $errorMessage'), findsOneWidget);
    });

    testWidgets('renders loaded state with results', (tester) async {
      final tResults = [
        const SearchResult(
          id: '1',
          name: 'iPhone 9',
          brand: 'Apple',
          price: 549,
          imageUrl: 'https://example.com/image.jpg',
          rating: 4.5,
          reviews: 10,
        ),
      ];
      when(() => mockSearchBloc.state).thenReturn(SearchLoaded(tResults));

      await HttpOverrides.runZoned(
        () async {
          await tester.pumpWidget(createWidgetUnderTest());
          // Allow network image to "resolve" (though mocked)
          await tester.pump(); 
        },
        createHttpClient: (_) {
          final client = MockHttpClient();
          final request = MockHttpClientRequest();
          final response = MockHttpClientResponse();
          final headers = MockHttpHeaders();

          when(() => client.getUrl(any())).thenAnswer((_) async => request);
          when(() => request.headers).thenReturn(headers);
          when(() => request.close()).thenAnswer((_) async => response);
          when(() => response.statusCode).thenReturn(200);
          when(() => response.contentLength).thenReturn(0);
          when(() => response.listen(any())).thenAnswer((invocation) {
             // Return empty stream
             return Stream<List<int>>.fromIterable([]).listen(invocation.positionalArguments.first as void Function(List<int>)?);
          });
          
          return client;
        },
      );

      expect(find.byType(ProductCard), findsOneWidget);
      expect(find.text('iPhone 9'), findsOneWidget);
    });

    testWidgets('triggers search on text change', (tester) async {
      when(() => mockSearchBloc.state).thenReturn(SearchInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'iphone');
      
      // Debounce logic is in Bloc, UI sends event immediately
      verify(() => mockSearchBloc.add(const SearchQueryChanged('iphone'))).called(1);
    });
  });
}
