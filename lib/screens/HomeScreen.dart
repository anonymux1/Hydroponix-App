import 'package:Hydroponix/models/System.dart';
import 'package:Hydroponix/screens/addSystem/SystemDiscover.dart';
import 'package:Hydroponix/screens/addSystem/SystemInfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Hydroponix/services/home_controller.dart';

class HomeScreen extends StatefulWidget {
@override
_HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  late RxList<System>? userSystems;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Or Column, ListView as needed
        child: Column(
          children: [
            // Hero Banner (Placeholder for now)
            SizedBox(height: 150, child: Container(color: Colors.blueGrey[300])),

            // Alerts Section ...

            // Systems Lane
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Text('My Hydroponix Systems'), // Section Title

                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => SystemDiscoverScreen(homeController.userSystems));
                    },
                    child: const Text('ADD NEW SYSTEM'),
                  ),
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
