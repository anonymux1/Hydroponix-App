import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Or your preferred state management
import 'package:http/http.dart' as http; // For API calls
import 'package:Hydroponix/services/systeminfo_controller.dart';
import '../../models/SystemList.dart';
import 'SystemNetworkCredentials.dart';

class SystemInfoScreen extends StatefulWidget {
  final SystemList? userSystems;
  const SystemInfoScreen(this.userSystems, {Key? key}) : super(key: key); // Constructor

  @override
  _SystemInfoScreenState createState() => _SystemInfoScreenState();
}

class _SystemInfoScreenState extends State<SystemInfoScreen> {
  final SystemInfoController systemInfoController = Get.find();
  var isLoading = true.obs;
  @override
  void initState() {
    super.initState();
    _fetchSystemData();
  }

  Future<void> _fetchSystemData() async {
    final url = Uri.http('192.168.1.1', '/systemInfo');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Parse the response (Assuming JSON)
        final parsedData = jsonDecode(response.body); // JSON key:value - version: "pro/hobby", sensors: "comma separated", switches: "int"
        systemInfoController.updateSystemInfo(widget.userSystems, parsedData); // Update controller
        isLoading.value = false;
      } else {
        // Handle error (e.g., display a message)
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Failed to fetch system data. Please check network connection.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _fetchSystemData(); // Retry fetching data
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      _showErrorDialog();
    }
  }
   void _showErrorDialog() {   // Handle network errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Failed to fetch system data. Please check network connection.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _fetchSystemData(); // Retry fetching data
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("System Information")),
      body: Obx(() {
      if (isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Column(
          children: [
            Text("Detected Version: ${systemInfoController.newSystem?.version}"),
            Text("Number of Switches: ${systemInfoController.newSystem?.switches}"),
            if(systemInfoController.newSystem?.version == "PRO")
              _buildProNetworkOption(),
            ElevatedButton(
              onPressed: () {
                    Get.to(() => NetworkCredentialsScreen(widget.userSystems, false));
              },
              child: const Text('NEXT'),
            ),
          ],
        );
      }
    }),
    );
  }

  Widget _buildProNetworkOption() {
    return Column(
      children: [
        Text('Select a WiFi network or use the in-built 2G network for internet?'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Choose network
                Get.to(() => NetworkCredentialsScreen(widget.userSystems, false));
              },
              child: Text('Choose WiFi'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => NetworkCredentialsScreen(widget.userSystems, true));
                },
              child: Text('Use 2G Data'),
            ),
          ],
        ),
      ],
    );
  }
}