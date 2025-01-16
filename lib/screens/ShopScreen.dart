import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/ListItemSelector.dart';
import '../services/shop_controller.dart';

final ShopController controller = Get.put(ShopController());

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  Widget _recommendedProductListView(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: controller.allProducts.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFFEC6813),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '30% OFF DURING \nCOVID 19',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9C46FF),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              "Get Now",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      controller.allProducts[index].mainImage,
                      height: 125,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _topCategoriesHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Top categories",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
            child: Text(
              "SEE ALL",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.deepOrange.withOpacity(0.7),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _topCategoriesListView() {
    return ListItemSelector(
      categories: controller.categories,
      onItemPressed: (index) {
        controller.filterItemsByCategory(index);
      },
    );
  }

  // final _systemsController = Get.put(SystemsController()); // Initialize controller
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Or Column, ListView as needed
        child: Column(
          children: [
            // Hero Banner (Placeholder for now)
            SizedBox(height: 150, child: Container(color: Colors.grey[300])),

            // Alerts Section ...

            // Systems Lane
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Shop Screen'), // Section Title
                  SizedBox(height: 10),
                  // GetBuilder to display cards based on systemsController data
                ],
              ),
            ),

            // Shop/Offers Section ...
          ],
        ),
      ),
    );
  }
}
