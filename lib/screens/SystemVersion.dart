import 'dart:convert';
import 'package:Hydroponix/screens/SystemModulesMapping.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Or your preferred state management
import 'package:http/http.dart' as http; // For API calls
import 'package:Hydroponix/services/systems_controller.dart';

class SystemVersionScreen extends StatefulWidget {
  @override
  _SystemVersionScreenState createState() => _SystemVersionScreenState();
}

class _SystemVersionScreenState extends State<SystemVersionScreen> {
  final SystemInfoController systemInfoController = Get.find();

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
        final parsedData = jsonDecode(response.body);
        setState(() {
          systemInfoController
              .updateSystemInfo(parsedData); // Update controller
        });
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
      appBar: AppBar(title: Text("System Sensors")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (systemInfo.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          Text("Detected Version: ${systemInfoController.version}"),
          Text("Number of Switches: "),
          Expanded(
            child: ListView.builder(
                itemCount: systemInfo.sensors.length,
                itemBuilder: (context, index) {
                  final sensorName = _systemInfo.sensors.keys.toList()[index];
                  final isPresent = _systemInfo.sensors[sensorName]!;
                  List<Widget> widgets = [
                    ListTile(
                      title: Text(sensorName),
                      trailing: isPresent
                          ? Icon(Icons.check, color: Colors.green)
                          : Icon(Icons.close, color: Colors.red),
                    ),
                  ];
                  if (_systemInfo.version == 'HOBBY') {
                    widgets.add(Text(
                        'Plug in both the air and water pumps & place the water pump and the air stone in the nutrient reservoir'));
                  } else if (_systemInfo.version == 'PRO') {
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
              if (systemInfoController.systemInfo.value?.version == 'HOBBY') {
                Get.to(() => SystemModulesMappingScreen());
              } else if (systemInfoController.systemInfo.value?.version == 'PRO') {
                Get.to(() => SystemModulesSelectionScreen());
              }
            },
            child: const Text('NEXT'),
          ),
        ],
      );
    }
  }
}