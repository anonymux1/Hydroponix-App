import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/shop_controller.dart';

class ShopSearchBar extends StatelessWidget {
  final ShopController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (query) {
          controller.searchProducts(query);
        },
      ),
    );
  }
}