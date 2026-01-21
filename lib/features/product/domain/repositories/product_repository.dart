import 'package:ecommerce_app/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/search/domain/entities/search_result.dart';

abstract class ProductRepository {
  Future<ProductEntity> getProductDetails(String id);
  Future<List<SearchResult>> getRelatedProducts(String categoryId);
}
