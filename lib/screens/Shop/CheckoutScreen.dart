import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:upi_pay/upi_pay.dart';
import '../../services/cart_controller.dart';
import '../../services/order_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.put(OrderController());
  final TextEditingController couponController = TextEditingController();
  RxString selectedPaymentMethod = 'UPI'.obs;
  RxDouble total = 0.0.obs;
  List<ApplicationMeta> upiApps = [];
  final upiPay = UpiPay();

  @override
  void initState() {
    super.initState();
    fetchUpiApps();
    total.value = CartController().totalPrice.value;
  }

  void fetchUpiApps() async {
    List<ApplicationMeta> apps = await upiPay.getInstalledUpiApplications();
    setState(() {
      upiApps = apps;
    });
  }

  void initiateTransaction(ApplicationMeta app) async {
    final transactionRef = DateTime.now().millisecondsSinceEpoch.toString();
    final transactionResult = await upiPay.initiateTransaction(
      amount: total.value.toStringAsFixed(2),
      app: app.upiApplication, // this is important!
      receiverName: dotenv.env['RECEIVER_NAME']!,
      receiverUpiAddress: dotenv.env['RECEIVER_UPI_ID']!,
      transactionRef: transactionRef,
      transactionNote: 'Payment for order',
    );
    print('Transaction result: ${transactionResult.status}');
    // You can add handling for different statuses here.
  }

  @override
  Widget build(BuildContext context) {
    RxDouble total = 0.0.obs;
    total.value = cartController.totalPrice.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  'Total Amount: \$${total.value.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
            const SizedBox(height: 20),
            TextField(
              controller: couponController,
              decoration: InputDecoration(
                labelText: 'Coupon Code',
                suffixIcon: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    // Apply coupon logic here
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('${orderController.selectedAddress['title']} \n'
                '${orderController.selectedAddress['line1']},'
                '${orderController.selectedAddress['line2']},'
                '${orderController.selectedAddress['city']},'
                '${orderController.selectedAddress['state']},'
                '${orderController.selectedAddress['pin']}. Phone:'
                '${orderController.selectedAddress['phone']}'),
            const SizedBox(height: 20),
            Text(
              'Select Payment Method',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: upiApps.length,
                itemBuilder: (context, index) {
                  final app = upiApps[index];
                    return GestureDetector(
                      onTap: () => initiateTransaction(app),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: app.iconImage(50), // directly use the Image
                            ),
                            const SizedBox(height: 4),
                            Text(app.upiApplication.appName),
                          ],
                        ),
                      ),
                    );
                  },
              ),
            ),
            Obx(() {
              return Column(
                children: [
                  RadioListTile(
                    title: Text('UPI'),
                    value: 'UPI',
                    groupValue: selectedPaymentMethod.value,
                    onChanged: (value) {
                      selectedPaymentMethod.value = value.toString();
                    },
                  ),
                  RadioListTile(
                    title: Text('Credit Card'),
                    value: 'Credit Card',
                    groupValue: selectedPaymentMethod.value,
                    onChanged: (value) {
                      selectedPaymentMethod.value = value.toString();
                    },
                  ),
                  RadioListTile(
                    title: Text('Debit Card'),
                    value: 'Debit Card',
                    groupValue: selectedPaymentMethod.value,
                    onChanged: (value) {
                      selectedPaymentMethod.value = value.toString();
                    },
                  ),
                  RadioListTile(
                    title: Text('Net Banking'),
                    value: 'Net Banking',
                    groupValue: selectedPaymentMethod.value,
                    onChanged: (value) {
                      selectedPaymentMethod.value = value.toString();
                    },
                  ),
                  RadioListTile(
                    title: Text('Payment Wallets'),
                    value: 'Payment Wallets',
                    groupValue: selectedPaymentMethod.value,
                    onChanged: (value) {
                      selectedPaymentMethod.value = value.toString();
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await orderController.placeOrder(
                    cartController.cartProducts,
                    orderController.selectedAddress,
                    selectedPaymentMethod.value,
                    couponController.text,
                    total.value,
                  );
                  cartController.clearCart();
                  Get.snackbar('Order Placed',
                      'Your order has been placed successfully!');
                  Get.offAllNamed('/home');
                },
                child: const Text('Confirm Purchase'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
