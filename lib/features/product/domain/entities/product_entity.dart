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
  // New fields
  final String handle;
  final String? subtitle;
  final List<ProductVariantEntity> variants;
  final List<String> tags; // Simplified tags for now
  final List<ProductTabEntity> tabs; // For accordion sections

  const ProductEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
    required this.images,
    required this.rating,
    required this.reviews,
    required this.handle,
    this.subtitle,
    this.variants = const [],
    this.tags = const [],
    this.tabs = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        price,
        description,
        images,
        rating,
        reviews,
        handle,
        subtitle,
        variants,
        tags,
        tabs
      ];
}

class ProductVariantEntity extends Equatable {
  final String id;
  final String title;
  final double price;
  final String? inventoryQuantity; 

  const ProductVariantEntity({
    required this.id, 
    required this.title, 
    required this.price,
    this.inventoryQuantity,
  });

  @override
  List<Object?> get props => [id, title, price, inventoryQuantity];
}

class ProductTabEntity extends Equatable {
  final String title;
  final String content;

  const ProductTabEntity({required this.title, required this.content});

  @override
  List<Object?> get props => [title, content];
}
