import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/search/domain/entities/search_result.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProductEntity> getProductDetails(String id) async {
    return await remoteDataSource.getProductDetails(id);
  }

  @override
  Future<List<SearchResult>> getRelatedProducts(String categoryId) async {
    return await remoteDataSource.getRelatedProducts(categoryId);
  }
}
