import 'dart:convert';
import 'package:Hydroponix/screens/addSystem/SystemModulesMapping.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Or your preferred state management
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http; // For API calls
import 'package:Hydroponix/services/systeminfo_controller.dart';
import 'SystemModulesSelection.dart';

class SystemInfoScreen extends StatefulWidget {
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
    final url = Uri.http('192.168.1.1', '/systeminfo');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Parse the response (Assuming JSON)
        final parsedData = jsonDecode(response.body); // JSON key:value - version: "pro/hobby", sensors: "comma separated", switches: "int"
        systemInfoController.updateSystemInfo(parsedData); // Update controller
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
      // Handle network errors
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("System Information")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          Text("Detected Version: ${systemInfoController.systemsList.value.systems?.last.version}"),
          Text("Number of Switches: ${systemInfoController.systemsList.value.systems?.last.switches}"),
          Text("Number of Heavy Duty Switches: ${systemInfoController.systemsList.value.systems?.last.heavySwitches}"),
          Expanded(
            child: ListView.builder(
                itemCount: systemInfoController.systemsList.value.systems?.last.sensors?.length ?? 0,
                itemBuilder: (context, index) {
                  final sensorName = systemInfoController.systemsList.value.systems?.last.sensors?.keys.toList()[index] ?? '';
                  final isPresent = systemInfoController.systemsList.value.systems?.last.sensors?[sensorName] ?? false;
                  List<Widget> widgets = [
                    ListTile(
                      title: Text(sensorName),
                      trailing: isPresent
                          ? Icon(Icons.check, color: Colors.green)
                          : Icon(Icons.close, color: Colors.red),
                    ),
                  ];
                  if (systemInfoController.systemsList.value.systems?.last.version == 'HOBBY') {
                    widgets.add(Text(
                        'Plug in both the air and water pumps & place the water pump and the air stone in the nutrient reservoir'));
                  } else if (systemInfoController.systemsList.value.systems?.last.version == 'PRO') {
                    widgets.add(Text('Plug in all the modules for your system.'));
                    widgets.add(Text('In the light duty switches, plug in air pump, water pump, LED lights, humidifier'));
                    widgets.add(Text('In the heavy duty switches, plug in water heater, water chiller, Desert Air Cooler / AC'));
                  }
                  return Column(
                      children: widgets); // Return the widgets within a Column
                }),
          ),
          ElevatedButton(
            onPressed: () {
              if (systemInfoController.systemsList.value.systems?.last.version == 'HOBBY') {
                Get.to(() => SystemModulesMappingScreen(systemInfoController.systemsList.value.systems?.last.systemId));
              } else if (systemInfoController.systemsList.value.systems?.last.version == 'PRO') {
                Get.to(() => SystemModulesSelectionScreen(systemInfoController.systemsList.value.systems?.last.systemId));
              }
            },
            child: const Text('NEXT'),
          ),
        ],
      );
    }
  }
}