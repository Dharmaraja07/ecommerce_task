import 'package:ecommerce_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:ecommerce_app/features/search/domain/entities/search_result.dart';
import 'package:ecommerce_app/features/search/domain/repositories/search_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SearchResult>> searchProducts(String query) async {
    return await remoteDataSource.searchProducts(query);
  }

  @override
  Future<List<SearchResult>> getTrendingProducts() async {
    // Reusing search endpoint for trending mock data for now
    return await remoteDataSource.searchProducts('trending');
  }
}
