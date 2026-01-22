import 'package:ecommerce_app/features/product/domain/entities/product_entity.dart';


abstract class ProductRepository {
  Future<ProductEntity> getProductDetails(String handle);
  Future<List<ProductEntity>> getProducts({int page = 1, int limit = 10, String? search, String? sort});
  Future<List<ProductEntity>> getRelatedProducts(String handle);
}
