import 'package:ecommerce_app/features/product/domain/entities/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable(createFactory: false, createToJson: false)
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
    required super.handle,
    super.subtitle,
    super.variants,
    super.tags,
    super.tabs,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Brand logic
    String brandName = '';
    if (json['brand'] is Map) {
      brandName = json['brand']['title'] ?? '';
    } else if (json['brandId'] != null) {
      // Fallback if brand object missing
      brandName = 'Brand'; // Or fetch from ID? For now placeholder or generic
    }

    // Price logic
    double price = 0.0;
    if (json['priceStart'] != null) {
      price = (json['priceStart'] as num).toDouble();
    } else if (json['variants'] != null && (json['variants'] as List).isNotEmpty) {
      price = (json['variants'][0]['price'] as num).toDouble();
    }
    
    // Images logic
    List<String> imagesList = [];
    if (json['productImages'] != null) {
      imagesList = (json['productImages'] as List)
          .map((e) => "https://api.virgincodes.com/${e['image']}")
          .toList();
    } else if (json['thumbnail'] != null) {
       imagesList.add("https://api.virgincodes.com/${json['thumbnail']}");
    }

    // Variants logic
    List<ProductVariantModel> variantsList = [];
    if (json['variants'] != null) {
      variantsList = (json['variants'] as List)
          .map((e) => ProductVariantModel.fromJson(e))
          .toList();
    }

    // Tags
    List<String> tagsList = [];
    if (json['tags'] != null) {
      tagsList = (json['tags'] as List).map((e) => e['tag']['title'] as String? ?? '').where((e) => e.isNotEmpty).toList();
    }
    
    // Tabs (Ingredients, How to Use) - usually in description or separate?
    // API example shows "tabs" array in example.txt
    List<ProductTabModel> tabsList = [];
    if (json['tabs'] != null) {
      tabsList = (json['tabs'] as List).map((e) => ProductTabModel.fromJson(e)).toList();
    }


    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['title'] as String? ?? '',
      brand: brandName,
      price: price,
      description: json['description'] as String? ?? '',
      images: imagesList,
      rating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviewsCount'] as int? ?? 0,
      handle: json['handle'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      variants: variantsList,
      tags: tagsList,
      tabs: tabsList,
    );
  }
}

@JsonSerializable()
class ProductVariantModel extends ProductVariantEntity {
  const ProductVariantModel({
    required super.id,
    required super.title,
    required super.price,
    super.inventoryQuantity,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantModelFromJson(json);
}

@JsonSerializable()
class ProductTabModel extends ProductTabEntity {
  const ProductTabModel({
    required super.title, 
    required super.content
  });

  factory ProductTabModel.fromJson(Map<String, dynamic> json) => _$ProductTabModelFromJson(json);
}
