import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReviewService {
  static String apiKey = dotenv.env['JUDGE_ME_API_KEY'] ?? '';
  static const String _baseUrl = "https://judge.me/api/v1/reviews";
  static Future<Map<String, dynamic>?> fetchReviews(String productId) async {
    try{
    final response = await http.get(
      Uri.parse('$_baseUrl?api_token=$apiKey&product_id=$productId'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load reviews');
    }
  } catch (e) {
    print('Error fetching reviews: $e');
    throw e;
  }
  }
}