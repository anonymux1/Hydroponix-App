// import 'dart:math';
// import 'package:flutter/material.dart' show Color;
import 'package:get/get.dart';
import 'package:Hydroponix/models/Product.dart';

extension IterableExtension<T> on Iterable<T> {
  Iterable<E> mapWithIndex<E>(E Function(int index, T value) f) {
    return Iterable.generate(length).map((i) => f(i, elementAt(i)));
  }
}

extension StringExtension on String {
  String get nextLine {
    if (length < 15) {
      return this;
    } else {
      return "${substring(0, 15)} \n${substring(15, length)}";
    }
  }
}

class CartController extends GetxController {

  List<Product> cartProducts = <Product>[].obs;
  RxDouble totalPrice = 0.0.obs;
  bool isPriceOff(Product product) => product.off != null;
  bool get isEmptyCart => cartProducts.isEmpty;
  int get productsCount => cartProducts.length; // Expose count

  void increaseItemQuantity(Product product) {
    product.quantity++;
    calculateTotalPrice();
    update();
  }

  void addToCart(Product product) {
    product.quantity++;
    cartProducts.add(product);
    cartProducts.assignAll(cartProducts);
    calculateTotalPrice();
  }

  void removeFromCart(Product product) {
    cartProducts.remove(product);
    calculateTotalPrice();
    update();
  }

  void decreaseItemQuantity(Product product) {
    product.quantity--;
    calculateTotalPrice();
    update();
  }

  void calculateTotalPrice() {
    totalPrice.value = 0;
    for (var element in cartProducts) {
      if (isPriceOff(element)) {
        totalPrice.value += element.quantity * element.off!;
      } else {
        totalPrice.value += element.quantity * element.price;
      }
    }
  }

  String getCurrentSize(Product product) {
    String currentSize = "";
    if (product.sizes?.categorical != null) {
      for (var element in product.sizes!.categorical!) {
        if (element.isSelected) {
          currentSize = "Size: ${element.categorical.name}";
        }
      }
    }

    if (product.sizes?.numerical != null) {
      for (var element in product.sizes!.numerical!) {
        if (element.isSelected) {
          currentSize = "Size: ${element.numerical}";
        }
      }
    }
    return currentSize;
  }

  getCartItems() {
    cartProducts.assignAll(cartProducts.where((item) => item.quantity > 0));
  }
}