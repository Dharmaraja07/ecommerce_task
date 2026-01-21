import 'package:dio/dio.dart';
import 'package:ecommerce_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:ecommerce_app/features/search/data/models/search_result_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late SearchRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = SearchRemoteDataSourceImpl(mockDio);
  });

  group('searchProducts', () {
    const tQuery = 'iphone';
    final tSearchResultModel = SearchResultModel(
      id: '1',
      name: 'iPhone 9',
      brand: 'Apple',
      price: 549,
      image: 'https://i.dummyjson.com/data/products/1/thumbnail.jpg',
      rating: 4.69,
      reviews: 94,
    );
    final tResponseData = {
      'results': [
        {
          "id": "1",
          "name": "iPhone 9",
          "brand": "Apple",
          "price": 549,
          "image": "https://i.dummyjson.com/data/products/1/thumbnail.jpg",
          "rating": 4.69,
          "reviews": 94
        }
      ]
    };

    test('should return List<SearchResultModel> when the response code is 200',
        () async {
      // arrange
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: tResponseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: '/search'),
              ));
      // act
      final result = await dataSource.searchProducts(tQuery);
      // assert
      expect(result, equals([tSearchResultModel]));
    });

    test('should throw Exception when the response code is not 200', () async {
      // arrange
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: 'Something went wrong',
                statusCode: 404,
                requestOptions: RequestOptions(path: '/search'),
              ));
      // act
      final call = dataSource.searchProducts;
      // assert
      expect(() => call(tQuery), throwsException);
    });
  });
}
