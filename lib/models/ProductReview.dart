import 'package:Hydroponix/models/Review.dart';
import 'package:Hydroponix/services/reviews_provider.dart';

class ProductReview {
  double rating;
  int reviewCount;
  List<Review>? reviews;

  ProductReview({
    required this.rating,
    required this.reviewCount,
    required this.reviews,
  });
  // Convert Firestore document to ProductReview object
  factory ProductReview.fromJson(Map<String, dynamic> data) {
    return ProductReview(
      rating: (data['rating'] as num).toDouble(),
      reviewCount: data['reviewCount'],
      reviews: (data['reviews'] as List<dynamic>)
          .map((reviewData) => Review.fromJson(reviewData))
          .toList(),
    );
  }
   Future<ProductReview?> loadReviews(String productId) async {
    try {
      final data = await ReviewService.fetchReviews(productId);
      if (data != null) {
        return ProductReview.fromJson(data);
      }
    } catch (e) {
      print("Error loading reviews: $e");
    }
    return null;
  }
}
