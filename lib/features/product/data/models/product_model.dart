import 'package:json_annotation/json_annotation.dart';
import 'package:ecommerce_app/features/product/domain/entities/product_entity.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.price,
    required super.description,
    required super.images,
    required super.rating,
    required super.reviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
