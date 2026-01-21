import 'package:ecommerce_app/features/search/domain/entities/search_result.dart';

abstract class SearchRepository {
  Future<List<SearchResult>> searchProducts(String query);
  Future<List<SearchResult>> getTrendingProducts();
}
