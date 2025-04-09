import 'package:Hydroponix/services/cart_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../components/CarouselSlider.dart';
import '../../models/Product.dart';
import '../../services/shop_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final HydroponixProduct product;
  const ProductDetailScreen(this.product, {super.key});
    @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ShopController controller = Get.put(ShopController());
  final CartController cartController = Get.put(CartController());
  late ProductVariant selectedVariant;

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  Widget productPageView(double width, double height) {
    return Container(
      height: height * 0.42,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E6E8),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(200),
          bottomLeft: Radius.circular(200),
        ),
      ),
      child: CarouselSlider(items: widget.product.images.map((image) {
        return image;
      }).toList(),),
    );
  }

  Widget _ratingBar(BuildContext context) {
    return Wrap(
      spacing: 30,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        RatingBar.builder(
          initialRating: widget.product.reviews!.rating,
          direction: Axis.horizontal,
          itemBuilder: (_, __) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (_) {},
        ),
        Text(
          "(${widget.product.reviews?.reviewCount} Reviews)",
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
  }

  Widget productSizesListView() {
    selectedVariant = widget.product.variants[0];
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.product.variants.length,
      itemBuilder: (_, index) {
        final variant = widget.product.variants[index];
        bool isSelected = selectedVariant.id == variant.id; // Check if variant is selected
        return InkWell(
          onTap: () => selectedVariant = variant,
          child: AnimatedContainer(
            margin: const EdgeInsets.only(right: 5, left: 5),
            alignment: Alignment.center,
            width: 70,
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
                width: 0.4,
              ),
            ),
            duration: const Duration(milliseconds: 300),
            child: FittedBox(
              child: Text(
                variant.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  productPageView(width, height),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 10),
                        _ratingBar(context),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text("${selectedVariant.price}",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const SizedBox(width: 3),
                            Visibility(
                              visible: selectedVariant.compareAtPrice!=null ? selectedVariant.compareAtPrice! > selectedVariant.price ?true:false : false,
                              child: Text(
                                "${selectedVariant.compareAtPrice}",
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              selectedVariant.availableForSale ? "Available in stock" : "Not available",
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "About",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(widget.product.description),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          child: GetBuilder<ShopController>(
                            builder: (_) => productSizesListView(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.product.isAvailableForSale ? () => cartController.addToCart(widget.product.id, selectedVariant.id ) : null,
                            child: const Text("Add to cart"),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}