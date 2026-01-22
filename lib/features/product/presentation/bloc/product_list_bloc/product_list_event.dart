part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object> get props => [];
}

class ProductListStarted extends ProductListEvent {}

class ProductListScrolled extends ProductListEvent {}

class ProductListSearched extends ProductListEvent {
  final String query;

  const ProductListSearched(this.query);

  @override
  List<Object> get props => [query];
}
