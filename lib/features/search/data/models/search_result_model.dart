import 'package:json_annotation/json_annotation.dart';
import 'package:ecommerce_app/features/search/domain/entities/search_result.dart';

part 'search_result_model.g.dart';

@JsonSerializable()
class SearchResultModel extends SearchResult {
  @JsonKey(name: 'image')
  final String image;

  const SearchResultModel({
    required String id,
    required String name,
    required String brand,
    required double price,
    required this.image,
    required double rating,
    required int reviews,
  }) : super(
          id: id,
          name: name,
          brand: brand,
          price: price,
          imageUrl: image,
          rating: rating,
          reviews: reviews,
        );

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultModelToJson(this);
}
