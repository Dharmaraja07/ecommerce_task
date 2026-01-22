import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';

import 'package:injectable/injectable.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProductEntity> getProductDetails(String handle) async {
    return await remoteDataSource.getProductDetails(handle);
  }

  @override
  Future<List<ProductEntity>> getProducts({int page = 1, int limit = 10, String? search, String? sort}) async {
    return await remoteDataSource.getProducts(page: page, limit: limit, search: search, sort: sort);
  }

  @override
  Future<List<ProductEntity>> getRelatedProducts(String handle) async {
    return await remoteDataSource.getRelatedProducts(handle);
  }
}
