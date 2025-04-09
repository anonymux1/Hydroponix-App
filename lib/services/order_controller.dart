import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cartProduct.dart';
import 'cart_controller.dart';
import 'package:Hydroponix/services/payment.dart';

class OrderController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late RxMap<String, dynamic> selectedAddress = <String, dynamic>{}.obs;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final PhonePeService phonePeService = PhonePeService();

  Future<void> placeOrder(
    List<CartProduct> cartProducts,
    Map<String, dynamic> address,
    String paymentMethod,
    String couponCode,
      double totalPrice,
  ) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    final orderData = {
      'userId': user.uid,
      'products': cartProducts.map((product) => product.toFirestore()).toList(),
      'totalPrice': totalPrice,
      'address': address,
      'paymentMethod': paymentMethod,
      'couponCode': couponCode,
      'timestamp': FieldValue.serverTimestamp(),
    };
    // Save order to Firestore
    await FirebaseFirestore.instance.collection('orders').add(orderData);
    //Try to place order based on the payment method
    try {
      final orderId = 'ORDER_ID_${DateTime.now().millisecondsSinceEpoch}';
      final response = await phonePeService.createPaymentRequest(totalPrice, orderId);
      // Handle the response, e.g., redirect to the payment page
      print(response);
    } catch (e) {
      print('Error: $e');
    }
  }
}