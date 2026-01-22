import 'package:dio/dio.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:injectable/injectable.dart';

abstract class ProductRemoteDataSource {
  Future<ProductModel> getProductDetails(String handle);
  Future<List<ProductModel>> getProducts({int page = 1, int limit = 10, String? search, String? sort});
  Future<List<ProductModel>> getRelatedProducts(String handle);
}

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<ProductModel> getProductDetails(String handle) async {
    // API uses handle/slug in path: /store/product/{handle}
    final response = await client.get('/store/product/$handle');
    
    if (response.statusCode == 200 && response.data['success'] == true) {
      return ProductModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to load product details');
    }
  }
  
  @override
  Future<List<ProductModel>> getProducts({int page = 1, int limit = 10, String? search, String? sort}) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }

    final response = await client.get('/store/product', queryParameters: queryParams);

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List data = response.data['data'];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<List<ProductModel>> getRelatedProducts(String handle) async {
    // There is no specific related endpoint in valid docs, but user mentioned "Related Products" in UI.
    // We can fetch products and filter or just return a few random ones.
    // Or maybe use the same category?
    // For now, let's fetch list (default) as related.
    // Or if we have a categoryID we could use that.
    // Let's just return getProducts with limit 5.
    try {
      return await getProducts(page: 1, limit: 5);
    } catch (_) {
      return [];
    }
  }
}
