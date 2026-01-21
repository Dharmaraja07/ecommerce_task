import 'package:ecommerce_app/features/search/domain/entities/search_result.dart';
import 'package:ecommerce_app/features/search/domain/repositories/search_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SearchProducts {
  final SearchRepository repository;

  SearchProducts(this.repository);

  Future<List<SearchResult>> call(String query) async {
    return await repository.searchProducts(query);
  }
}
