import 'package:dio/dio.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:ecommerce_app/features/search/data/models/search_result_model.dart';
import 'package:injectable/injectable.dart';

abstract class ProductRemoteDataSource {
  Future<ProductModel> getProductDetails(String id);
  Future<List<SearchResultModel>> getRelatedProducts(String categoryId);
}

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<ProductModel> getProductDetails(String id) async {
    final response = await client.get('/product', queryParameters: {'id': id});
    
    if (response.statusCode == 200) {
      return ProductModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load product details');
    }
  }
  
  @override
  Future<List<SearchResultModel>> getRelatedProducts(String categoryId) async {
    // Reusing the same mock response logic for simplicity, fetching 'related' key if present or standard search
    final response = await client.get('/product', queryParameters: {'id': categoryId}); // Using product endpoint which has related
    if (response.statusCode == 200 && response.data['related'] != null) {
       final List related = response.data['related'];
       return related.map((e) => SearchResultModel.fromJson(e)).toList();
    }
    return [];
  }
}
