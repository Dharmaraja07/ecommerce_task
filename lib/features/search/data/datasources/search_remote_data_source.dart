import 'package:dio/dio.dart';
import 'package:ecommerce_app/features/search/data/models/search_result_model.dart';
import 'package:injectable/injectable.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchResultModel>> searchProducts(String query);
}

@LazySingleton(as: SearchRemoteDataSource)
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio client;

  SearchRemoteDataSourceImpl(this.client);

  @override
  Future<List<SearchResultModel>> searchProducts(String query) async {
    final response = await client.get('/search', queryParameters: {'q': query});
    
    if (response.statusCode == 200) {
      final List results = response.data['results'];
      return results.map((e) => SearchResultModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
