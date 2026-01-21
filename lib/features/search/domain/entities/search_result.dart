import 'package:equatable/equatable.dart';

class SearchResult extends Equatable {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final double rating;
  final int reviews;

  const SearchResult({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
  });

  @override
  List<Object?> get props => [id, name, brand, price, imageUrl, rating, reviews];
}
