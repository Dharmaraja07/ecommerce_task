part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  
  @override
  List<Object> get props => [];
}

class LoadProductDetails extends ProductEvent {
  final String id;

  const LoadProductDetails(this.id);

  @override
  List<Object> get props => [id];
}
