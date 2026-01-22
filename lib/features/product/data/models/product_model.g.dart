// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductVariantModel _$ProductVariantModelFromJson(Map<String, dynamic> json) =>
    ProductVariantModel(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      inventoryQuantity: json['inventoryQuantity'] as String?,
    );

Map<String, dynamic> _$ProductVariantModelToJson(
        ProductVariantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'inventoryQuantity': instance.inventoryQuantity,
    };

ProductTabModel _$ProductTabModelFromJson(Map<String, dynamic> json) =>
    ProductTabModel(
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$ProductTabModelToJson(ProductTabModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
    };
