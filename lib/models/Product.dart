import 'ProductSizeType.dart';
enum ProductType { all, plants, systems, hardware, produce }

class Product {
  String name;
  double price;
  int? off;
  String about;
  bool isAvailable;

  // ProductSizeType? sizes;
  int _quantity;
  String mainImage;
  List<String> images;
  bool isFavorite;
  double rating;
  ProductType type;
  ProductSizeType? sizes;
  int get quantity => _quantity;

  set quantity(int newQuantity) {
    if (newQuantity >= 0) _quantity = newQuantity;
  }

  Product({
    // this.sizes,
    required this.about,
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.off,
    required int quantity,
    required this.mainImage,
    required this.images,
    required this.isFavorite,
    required this.rating,
    required this.type,
  }) : _quantity = quantity;
}