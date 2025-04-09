import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:Hydroponix/models/Product.dart';
import 'package:Hydroponix/models/cartProduct.dart';

class CartController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxDouble totalPrice = 0.0.obs;
  RxInt totalItems = 0.obs;
  RxList<CartProduct> cartProducts = <CartProduct>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    initializeCart();
  }

  Future<void> initializeCart() async {
      final user = _auth.currentUser;
      if (user == null) {
        print("User is not logged in");
        return;
      }
      final firestore = FirebaseFirestore.instance;
      final userDoc = await firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists && docSnapshot.data()?['cart'] != null) {
        List<dynamic> cartData = docSnapshot.data()?['cart'];
        List<CartProduct> validCartProducts = [];
        bool cartModified = false; // Track if any items were removed
        for (var item in cartData) {
          CartProduct cartProduct = CartProduct.fromFirestore(item);
          DocumentSnapshot productSnapshot = await _firestore           // 🔍 Fetch product from Firestore
              .collection('products')
              .doc(cartProduct.productId)
              .get();

          if (!productSnapshot.exists) {
            print("Warning: Product ${cartProduct.productId} no longer exists.");
            cartModified = true; // Mark cart as modified
            continue; // Skip this item
          }
          Map<String, dynamic> productData = productSnapshot.data() as Map<String, dynamic>;            // 🔍 Check if variant exists
          List<dynamic> variants = productData['variants'] ?? [];
          bool variantExists = variants.any((variant) => variant['variantId'] == cartProduct.variantId);
          if (!variantExists) {
            print("Warning: Variant ${cartProduct.variantId} for product ${cartProduct.productId} not found.");
            cartModified = true; // Mark cart as modified
            continue; // Skip this item
          }
          validCartProducts.add(cartProduct); // ✅ Add to valid cart list
          totalItems.value++; // ✅ Update total items and price
          totalPrice.value += (productData['price'] as num) * cartProduct.quantity;
        }
        cartProducts.value = validCartProducts; // ✅ Update cartProducts with only valid products
        if (cartModified) {     // ✅ Save cart to Firestore only if it was modified
          await saveCartToFirestore();
        }
      }
  }

  Future<void> addToCart(String productId, String variantId) async {
    int index = cartProducts.indexWhere(
            (item) => item.productId == productId && item.variantId == variantId);
    if (index != -1) {
      // If product variant exists, increment quantity
      cartProducts[index].quantity++;
    } else {
      // Add new cart item
      cartProducts.add(CartProduct(productId: productId, variantId: variantId, quantity: 1));
    }
    await saveCartToFirestore();
  }

  Future<void> removeFromCart(CartProduct product) async {
    cartProducts.removeWhere((item) => item.productId == product.productId && item.variantId == product.variantId);
    await saveCartToFirestore();
  }

  Future<void> decreaseQuantity(String productId, String variantId) async {
    int index = cartProducts.indexWhere(
            (item) => item.productId == productId && item.variantId == variantId);

    if (index != -1) {
      if (cartProducts[index].quantity > 1) {
        cartProducts[index].quantity--;
      } else {
        cartProducts.removeAt(index); // Remove if only 1 left
      }
      await saveCartToFirestore();
    }
  }

  Future<void> saveCartToFirestore() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'cart': cartProducts.map((item) => item.toFirestore()).toList(),
      });
    }
  }

  Future<HydroponixProduct?> fetchProductDetails(String productId) async {
    final docSnapshot = await _firestore.collection('products').doc(productId).get();
    if (docSnapshot.exists) {
      return HydroponixProduct.fromJson(docSnapshot.data()!);
    }
    return null;
  }

  Future<RxList<HydroponixProduct>> fetchAllProducts() async {
    RxList<HydroponixProduct> allProducts = <HydroponixProduct>[].obs;
    for (var cartProduct in cartProducts) {
      HydroponixProduct? product = await fetchProductDetails(cartProduct.productId);
      if (product != null) {
        allProducts.add(product);
      }
    }
    return allProducts;
  }

  Future<void> clearCart() async {
    cartProducts.clear();
    totalItems.value = 0;
    totalPrice.value = 0;
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'cart': [],
      });
    }
  }
}