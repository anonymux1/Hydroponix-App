import 'package:Hydroponix/screens/Shop/ProductDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/shop_controller.dart';
import '../../components/ShopSearchBar.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ShopController controller = Get.put(ShopController());

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value == true) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else
        return Scaffold(
            body: Column(
          children: [
            ShopSearchBar(),
            HeroCarousel(controller: controller),
            CategoryFilterRow(controller: controller),
            Expanded(
              child: ProductGridView(controller: controller),
            ),
          ],
        ));
    });
  }
}

class HeroCarousel extends StatelessWidget {
  final ShopController controller;
  HeroCarousel({required this.controller});
  @override
  Widget build(BuildContext context) {
    if (controller.heroBanner.entries.isEmpty) return Container();
    return Container(
      height: 200,
      child: PageView(
        children: controller.heroBanner.entries.map((entry) {
          return GestureDetector(
            onTap: () {
              // Handle banner tap
              print('Banner clicked: ${entry.value}');
            },
            child: Image.network(
              entry.key,
              fit: BoxFit.cover,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CategoryFilterRow extends StatelessWidget {
  final ShopController controller;
  CategoryFilterRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(controller.categories[index]),
                    selected: false,
                    onSelected: (selected) {
                      // Handle category selection
                    },
                  ),
                );
              },
            ),
          ),
          DropdownButton<String>(
            items: <String>['Sort by', 'Price', 'Rating'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              // Handle sorting logic
            },
          ),
        ],
      ),
    );
  }
}

class ProductGridView extends StatelessWidget {
  final ShopController controller;
  ProductGridView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.filteredProducts.isEmpty) {
        return Center(child: CircularProgressIndicator());
      } else {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: controller.filteredProducts.length,
          itemBuilder: (context, index) {
            final product = controller.filteredProducts[index];
            return GestureDetector(
                onTap: () {
              Get.to(() => ProductDetailScreen(product));
            },child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    product.images.first,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Rating: ${product.reviews?.rating ?? ''}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                        Text('Reviews: ${product.reviews?.reviewCount ?? ''}'),
                  ),
                ],
              ),
            ));
          },
        );
      }
    });
  }
}
