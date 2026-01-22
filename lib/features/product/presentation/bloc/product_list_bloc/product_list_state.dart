part of 'product_list_bloc.dart';

enum ProductListStatus { initial, loading, success, failure }

class ProductListState extends Equatable {
  final ProductListStatus status;
  final List<ProductEntity> products;
  final bool hasReachedMax;
  final int currentPage;
  final String? searchQuery;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.searchQuery,
  });

  ProductListState copyWith({
    ProductListStatus? status,
    List<ProductEntity>? products,
    bool? hasReachedMax,
    int? currentPage,
    String? searchQuery,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, products, hasReachedMax, currentPage, searchQuery];
}
