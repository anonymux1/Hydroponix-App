import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Hydroponix/services/provisioning_controller.dart';
import 'package:Hydroponix/screens/addSystem/SystemInfo.dart';

class SystemProvisioningScreen extends StatefulWidget {
  @override
  _SystemProvisioningScreenState createState() =>
      _SystemProvisioningScreenState();
}

class _SystemProvisioningScreenState extends State<SystemProvisioningScreen> {
  final _controller = Get.put(provisioningController());
  final networkSSIDController = TextEditingController();
  final systemNameController = TextEditingController(); // Controller for the generated system ID
  final networkPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller
        .generateSystemId(); // Generate the system ID on screen initialization
  }

  Future<void> _showMyDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup Your Hydroponix System"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for better UI
        child: Obx(() {
          if (_controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (_controller.isProvisioned.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Show success dialog after the UI rebuilds
              _showMyDialog('Success', 'Provisioning Successful!');
              Timer(const Duration(milliseconds: 500), () { // Timer
                Get.to(() => SystemInfoScreen());
              });
            });
            return Center(child: CircularProgressIndicator()); // Temporary
          } else if (_controller.error.value.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Show error dialog after the UI rebuilds
              _showMyDialog('Error', _controller.error.value);
              _controller.error(''); // Reset the error
            });
            return Center(child: CircularProgressIndicator()); // Temporary
          } else {
            return Column(
              children: [
                if (_controller.isLoading.value) CircularProgressIndicator(),
                TextFormField(
                  controller: systemNameController,
                  decoration: InputDecoration(labelText: "System Name:"),
                ),
                TextFormField(
                  controller: networkSSIDController,
                  decoration: InputDecoration(labelText: "WiFi Name:"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: networkPasswordController,
                  decoration: InputDecoration(labelText: "WiFi Password"),
                ),
                SizedBox(height: 10),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _controller.sendCredentials(
                    systemNameController.text,
                    networkSSIDController.text,
                    networkPasswordController.text,
                  ),
                  child: Text("Provision"),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
