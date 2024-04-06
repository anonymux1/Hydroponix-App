import 'package:flutter/material.dart';
//import 'package:get/get.dart';
//import '../services/systeminfo_controller.dart'; // Import your controller

class AnalyzeScreen extends StatelessWidget {
  const AnalyzeScreen({super.key});

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
                  Text('Analyze Screen'), // Section Title
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
