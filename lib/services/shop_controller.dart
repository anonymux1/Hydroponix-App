import 'package:Hydroponix/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:Hydroponix/services/reviews_provider.dart';
import 'package:Hydroponix/services/cart_controller.dart';
import '../models/ProductReview.dart';

class ShopController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CartController cartController = Get.put(CartController());
  RxList<HydroponixProduct> products = <HydroponixProduct>[].obs;
  RxList<HydroponixProduct> filteredProducts = <HydroponixProduct>[].obs;
  RxBool isLoading = true.obs;
  RxList<String> categories = <String>[].obs;
  Map <String,String> heroBanner = <String,String>{};

  @override
  void onInit() {
    super.onInit();
    initShop();
  }

  Future<void> initShop() async {
    try {
      await fetchCategories();
      await fetchProducts();
      await fetchHeroBanner();
    } catch (e) {
      print("Error initializing shop: $e");
    } finally {
      isLoading.value = false;
    }
  }
  // Fetch categories from Firestore
  Future<void> fetchCategories() async {
    try {
      QuerySnapshot catSnapshot = await _firestore
          .collection('categories')
          .get();
      categories.value =
          catSnapshot.docs.map((doc) => doc['title'] as String).toList();
    } catch (e) {
      print("Error fetching  / categories: $e");
    }
  }
  // Fetch products from Firestore
    Future<void> fetchProducts() async {
      try {
        QuerySnapshot snapshot = await _firestore.collection('products').get();
        products.value = snapshot.docs.map((doc) {
          return HydroponixProduct.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
        await fetchProductReviews();
      } catch (e) {
        print("Error fetching products :$e");
      }
    }
    // Fetch reviews for each product
      Future<void> fetchProductReviews() async {
        for (var product in products) {
          try {
            Map<String, dynamic>? reviewData =
            await ReviewService.fetchReviews(product.id);
            if (reviewData != null) {
              product.reviews = ProductReview.fromJson(reviewData);
            }
          } catch (e) {
            print("Error fetching reviews for product ${product.id}: $e");
          }
        }
      }
  // Fetch hero banner from Firestore
  Future<void> fetchHeroBanner() async {
    try{
          QuerySnapshot banner = await _firestore.collection('heroBanner').get();
          if (banner.docs.isNotEmpty) {
            // Assuming you want to use the first document as the hero banner
             heroBanner = Map.fromEntries(
                 banner.docs.map((doc) {
                   var data = doc.data() as Map<String, dynamic>;
                   return MapEntry(data['image_url'] as String, data['click_url'] as String);
                 })
             );
          }
        }
        catch(e)  {
          print("Error fetching hero banner: $e");
        }
      }
  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((product) => product.title.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
}