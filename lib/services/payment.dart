import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PhonePeService {
  final String merchantId = dotenv.env['MERCHANT_ID']!;
  final String merchantKey = dotenv.env['MERCHANT_KEY']!;
  final String baseUrl = 'https://api.phonepe.com/apis/hermes';

  Future<Map<String, dynamic>> createPaymentRequest(double amount, String orderId) async {
    final url = Uri.parse('$baseUrl/v1/payments');
    final headers = {
      'Content-Type': 'application/json',
      'X-VERIFY': _generateXVerifyHeader(orderId),
    };
    final body = jsonEncode({
      'merchantId': merchantId,
      'transactionId': orderId,
      'amount': (amount * 100).toInt(), // Amount in paise
      'merchantOrderId': orderId,
      'merchantUserId': 'USER_ID',
      'redirectUrl': 'YOUR_REDIRECT_URL',
      'callbackUrl': 'YOUR_CALLBACK_URL',
      'paymentInstrument': {
        'type': 'PAY_PAGE',
      },
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create payment request');
    }
  }

  String _generateXVerifyHeader(String orderId) {
    final data = '$orderId$merchantKey';
    final hash = base64Encode(utf8.encode(data));
    return '$hash###1';
  }
}