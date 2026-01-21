import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String description;
  final List<String> images;
  final double rating;
  final int reviews;
  // We could add 'related products' here or handle it separately

  const ProductEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
    required this.images,
    required this.rating,
    required this.reviews,
  });

  @override
  List<Object?> get props => [id, name, brand, price, description, images, rating, reviews];
}
