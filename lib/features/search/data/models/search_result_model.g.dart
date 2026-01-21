// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultModel _$SearchResultModelFromJson(Map<String, dynamic> json) =>
    SearchResultModel(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: (json['reviews'] as num).toInt(),
    );

Map<String, dynamic> _$SearchResultModelToJson(SearchResultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'price': instance.price,
      'rating': instance.rating,
      'reviews': instance.reviews,
      'image': instance.image,
    };
