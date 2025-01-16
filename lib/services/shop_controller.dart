import 'package:Hydroponix/models/Product.dart';
import 'package:get/get.dart';
import 'package:shopify_flutter/shopify_config.dart';
import '../models/Numerical.dart';
import '../models/ProductCategory.dart';
import '../models/ProductSizeType.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shopify_flutter/shopify_flutter.dart';

class ShopController extends GetxController {
  List<Product> allProducts = [];
  RxList<Product> filteredProducts = <Product>[].obs;
  RxList<ProductCategory> categories = <ProductCategory>[].obs;

  void filterItemsByCategory(int index) {
    for (ProductCategory element in categories) {
      element.isSelected = false;
    }
    categories[index].isSelected = true;

    if (categories[index].type == ProductType.all) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(allProducts.where((item) {
        return item.type == categories[index].type;
      }).toList());
    }
    update();
  }

  void startShop() {
    ShopifyConfig.setConfig(
      storefrontAccessToken: dotenv.env['STOREFRONT_ACCESS_TOKEN'] ?? '',
      storeUrl: dotenv.env['STORE_URL'] ?? '',
      adminAccessToken: dotenv.env['ADMIN_ACCESS_TOKEN'],
      storefrontApiVersion: dotenv.env['STOREFRONT_API_VERSION'] ?? '2023-07',
      cachePolicy: CachePolicy.networkOnly,
      language: dotenv.env['LANGUAGE_LOCALE'] ?? 'en',
    );
  }

  void isFavorite(int index) {
    filteredProducts[index].isFavorite = !filteredProducts[index].isFavorite;
    update();
  }

  getFavoriteItems() {
    filteredProducts.assignAll(
      allProducts.where((item) => item.isFavorite),
    );
  }

  getAllItems() {
    filteredProducts.assignAll(allProducts);
  }

  List<Numerical> sizeType(Product product) {
    ProductSizeType? productSize = product.sizes;
    List<Numerical> numericalList = [];

    if (productSize?.numerical != null) {
      for (var element in productSize!.numerical!) {
        numericalList.add(Numerical(element.numerical, element.isSelected));
      }
    }

    if (productSize?.categorical != null) {
      for (var element in productSize!.categorical!) {
        numericalList.add(
          Numerical(
            element.categorical.name,
            element.isSelected,
          ),
        );
      }
    }

    return numericalList;
  }

  bool isNominal(Product product) => product.sizes?.numerical != null;

  void switchBetweenProductSizes(Product product, int index) {
    sizeType(product).forEach((element) {
      element.isSelected = false;
    });

    if (product.sizes?.categorical != null) {
      for (var element in product.sizes!.categorical!) {
        element.isSelected = false;
      }

      product.sizes?.categorical![index].isSelected = true;
    }

    if (product.sizes?.numerical != null) {
      for (var element in product.sizes!.numerical!) {
        element.isSelected = false;
      }

      product.sizes?.numerical![index].isSelected = true;
    }

    update();
  }

}