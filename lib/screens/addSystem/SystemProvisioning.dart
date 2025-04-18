// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Hydroponix/services/provisioning_controller.dart';
import '../../models/SystemList.dart';

class SystemProvisioningScreen extends StatefulWidget {
  final SystemList? userSystems;
  const SystemProvisioningScreen(this.userSystems, {Key? key})
      : super(key: key); // Constructor

  @override
  _SystemProvisioningScreenState createState() =>
      _SystemProvisioningScreenState();
}

class _SystemProvisioningScreenState extends State<SystemProvisioningScreen> {
  final _controller = Get.put(provisioningController());
  final networkSSID = TextEditingController();
  final systemName = TextEditingController();
  final networkPassword = TextEditingController();
  final airPumpDuration = TextEditingController();
  final airPumpInterval = TextEditingController();
  final waterPumpDuration = TextEditingController();
  final waterPumpInterval = TextEditingController();
  String _sel = "";
  late List<DropdownMenuItem<String>>? networks = _controller.getNetworks() as List<DropdownMenuItem<String>>?;

  @override
  void initState() {
    super.initState();
    // _controller.generateSystemId(); // Generate the system ID on screen initialization
  }

  // Future<void> _showMyDialog(String title, String message) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text(message),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Review your Hydroponix System Setup"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding for better UI
            child: Column(
              children: [
                TextFormField(
                  controller: systemName,
                  decoration: InputDecoration(labelText: "System Name:"),
                ),
                const Text("Select a Network"),
                DropdownButton<String>
                  (
                    value: _sel,
                    items: networks,
                    onChanged: (String? newValue) {
                                setState(() {
                                _sel = newValue!;
                                });}
                ),
                TextFormField(
                  controller: networkSSID,
                  decoration: InputDecoration(labelText: "WiFi Name:"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: networkPassword,
                  decoration: InputDecoration(labelText: "WiFi Password"),
                ),
                TextFormField(
                  controller: airPumpDuration,
                  decoration: InputDecoration(labelText: "Air Pump Duration"),
                ),
                TextFormField(
                  controller: airPumpInterval,
                  decoration: InputDecoration(labelText: "Air Pump Interval"),
                ),
                TextFormField(
                  controller: waterPumpDuration,
                  decoration: InputDecoration(labelText: "Water Pump Duration"),
                ),
                TextFormField(
                  controller: waterPumpInterval,
                  decoration: InputDecoration(labelText: "Water Pump Interval"),
                ),
                SizedBox(height: 10),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveAndProvision,
                  child: Text("Confirm"),
                ),
              ],

            )));
  }
  Future<void> _saveAndProvision() async {
    Get.defaultDialog(
      title: "Provisioning System",
      content: Obx(() {
        if (_controller.error.isNotEmpty) {
          return Column(
            children: [
              Icon(Icons.error, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text(_controller.error.value, textAlign: TextAlign.center),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _controller.error.value = ''; // Reset error
                  Get.back(); // Close dialog
                },
                child: Text("Retry"),
              ),
            ],
          );
        } else if (!_controller.isSaved.isTrue) {
          return Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text(_controller.isProvisioned.isTrue
                  ? "Updating Config on the Server"
                  : "Updating Config on Hydroponix System"),
            ],
          );
        } else {
          return Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text("Hydroponix System Configured Successfully"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.offAllNamed('/home'),
                child: Text("Home"),
              ),
            ],
          );
        }
      }),
      barrierDismissible: false,
    );

    await _controller.setCredentials(
      widget.userSystems,
      systemName.text,
      networkSSID.text,
      networkPassword.text,
      airPumpDuration.text,
      airPumpInterval.text,
      waterPumpDuration.text,
      waterPumpInterval.text,
    );
  }
}
