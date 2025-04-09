import 'package:Hydroponix/screens/Shop/CheckoutScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/cart_controller.dart';
import '../../services/order_controller.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);

  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final CartController cartController = Get.find<CartController>();
  OrderController orderController = Get.put(OrderController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController line1Controller = TextEditingController();
  final TextEditingController line2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final RxBool saveAddress = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select or Enter Shipping Address',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(orderController.userId)
                    .collection('addresses')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var addresses = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      var address = addresses[index];
                      return ListTile(
                        title: Text(address['title']),
                        subtitle: Text('${address['line1']}, ${address['city']}'),
                        onTap: () {
                          orderController.selectedAddress = address as RxMap<String, dynamic>;
                          Get.to(() => CheckoutScreen());
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Address Title'),
            ),
            TextField(
              controller: line1Controller,
              decoration: InputDecoration(labelText: 'Address Line 1'),
            ),
            TextField(
              controller: line2Controller,
              decoration: InputDecoration(labelText: 'Address Line 2'),
            ),
            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
            TextField(
              controller: pinController,
              decoration: InputDecoration(labelText: 'Pin'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            Row(
              children: [
                Obx(() => Checkbox(
                      value: saveAddress.value,
                      onChanged: (value) {
                        saveAddress.value = value!;
                      },
                    )),
                Text('Save Address'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var newAddress = {
                    'title': titleController.text,
                    'line1': line1Controller.text,
                    'line2': line2Controller.text,
                    'city': cityController.text,
                    'state': stateController.text,
                    'pin': pinController.text,
                    'phone': phoneController.text,
                  };
                  if (saveAddress.value) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(orderController.userId)
                        .collection('addresses')
                        .add(newAddress);
                  }
                  orderController.selectedAddress = newAddress as RxMap<String, dynamic>;
                  Get.to(() => CheckoutScreen());
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}