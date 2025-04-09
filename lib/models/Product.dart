import 'package:Hydroponix/models/ProductReview.dart';
class HydroponixProduct {
  String id;
  String title;
  String description;
  List<String> images;
  bool isAvailableForSale;
  List<ProductVariant> variants;
  ProductReview? reviews;
  String category;

  HydroponixProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.isAvailableForSale,
    required this.variants,
    required this.reviews,
    required this.category
  });

  // Convert Firestore document to Product object
  factory HydroponixProduct.fromJson(Map<String, dynamic> data) {
    return HydroponixProduct(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      images: List<String>.from(data['images'] ?? []),
      isAvailableForSale: data['isAvailableForSale'] ?? false,
      variants: (data['variants'] as List<dynamic>)
          .map((variant) => ProductVariant.fromJson(variant))
          .toList(),
      reviews: null,
      category: data['category'] ?? '',
    );
  }
}

class ProductVariant {
  String id;
  String title;
  double price;
  double? compareAtPrice;
  bool availableForSale;

  ProductVariant({
    required this.id,
    required this.title,
    required this.price,
    this.compareAtPrice,
    required this.availableForSale,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> data) {
    return ProductVariant(
      id: data['id'],
      title: data['title'],
      price: (data['price'] as num).toDouble(),
      compareAtPrice: data['compareAtPrice'] != null
          ? (data['compareAtPrice'] as num).toDouble()
          : null,
      availableForSale: data['availableForSale'] ?? false,
    );
  }
}
