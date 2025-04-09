import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Hydroponix/services/cart_controller.dart';
import '../../components/animations/AnimatedSwitcherWrapper.dart';
import '../../models/Product.dart';
import 'CheckoutScreen.dart';

class CartScreen extends StatelessWidget {
  final CartController controller = Get.put(CartController());
  CartScreen({Key? key}) : super(key: key);
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "My cart",
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }

  Widget emptyCart() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Image.asset('assets/images/empty_cart.png'),
          ),
        ),
        const Text(
          "Empty cart",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )
      ],
    );
  }

  Widget cartList(RxList<HydroponixProduct> products) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(products.length, (index) {
          final product = products[index];
          final variant = product.variants.firstWhere((variant) => variant.id == controller.cartProducts[index].variantId).title;
          final price = product.variants.firstWhere((variant) => variant.id == controller.cartProducts[index].variantId).price;
          final compareAtPrice = product.variants.firstWhere((variant) => variant.id == controller.cartProducts[index].variantId).compareAtPrice;
          final availableForSale = product.variants.firstWhere((variant) => variant.id == controller.cartProducts[index].variantId).availableForSale;
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[200]?.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          product.images.first,
                          width: 100,
                          height: 90,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text('$variant',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Visibility(
                          visible: compareAtPrice!=null ? compareAtPrice > price ?true:false : false,
                          child: Text(
                            "${compareAtPrice}",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text("${price}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                       Visibility(
                        visible: availableForSale ? true : false,
                        child: Text("Not available",
                          style: TextStyle(fontWeight: FontWeight.w500,
                          color: Colors.red),
                        )),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        splashRadius: 10.0,
                        onPressed: () =>
                            controller.decreaseQuantity(controller.cartProducts[index].productId, controller.cartProducts[index].variantId),
                        icon: const Icon(
                          Icons.remove,
                          color: Color(0xFFEC6813),
                        ),
                      ),
                      GetBuilder<CartController>(
                        builder: (CartController controller) {
                          return AnimatedSwitcherWrapper(
                            child: Text(
                              '${controller.cartProducts[index].quantity}',
                              key: ValueKey<int>(
                                controller.cartProducts[index].quantity,
                              ),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        splashRadius: 10.0,
                        onPressed: () =>
                            controller.addToCart(controller.cartProducts[index].productId, controller.cartProducts[index].variantId),
                        icon: const Icon(Icons.add, color: Color(0xFFEC6813)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ])]));
        }).toList(),
      ),
    );
  }

  Widget bottomBarTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          Obx(
                () {
              return AnimatedSwitcherWrapper(
                child: Text(
                  "\$${controller.totalPrice.value}",
                  key: ValueKey<int>(controller.totalPrice.value.toInt()),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFEC6813),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget bottomBarButton(bool hasProducts) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
          onPressed: hasProducts ? () {
            Get.to(() => CheckoutScreen());
          } : () {},
          child: const Text("Buy Now"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasProducts = false;
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child:  FutureBuilder<RxList<HydroponixProduct>>(
        future: controller.fetchAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return emptyCart();
          } else {
            hasProducts = true;
            return cartList(snapshot.data!);
          }
        },
      ),
          ),
          bottomBarTitle(),
          bottomBarButton(hasProducts)
        ],
      ),
    );
  }
}
