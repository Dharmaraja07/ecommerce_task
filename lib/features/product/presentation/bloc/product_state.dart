part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}
class ProductLoaded extends ProductState {
  final ProductEntity product;
  final List<ProductEntity> relatedProducts;

  const ProductLoaded(this.product, this.relatedProducts);

  @override
  List<Object> get props => [product, relatedProducts];
}
class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
  @override
  List<Object> get props => [message];
}
