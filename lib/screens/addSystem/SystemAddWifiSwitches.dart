import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/SystemList.dart';
import '../../services/addswitches_controller.dart';

class SystemAddWifiSwitchesScreen extends StatefulWidget {
  final SystemList? userSystems;
  const SystemAddWifiSwitchesScreen(this.userSystems, {Key? key}) : super(key: key);
  @override
  _SystemAddWifiSwitchesScreenState createState() => _SystemAddWifiSwitchesScreenState();
  }

class _SystemAddWifiSwitchesScreenState extends State<SystemAddWifiSwitchesScreen> {
  final AddSwitchesController controller = Get.put(AddSwitchesController());

  @override
  void initState() {
    super.initState();
    controller.scanForNetworks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Wi-Fi Switches")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return Column(
                children: [
                  DropdownButton<String>(
                    hint: Text("Select SSID"),
                    value: controller.selectedNetwork.value.isEmpty ? null : controller.selectedNetwork.value,
                    items: controller.availableNetworks.map((network) {
                      return DropdownMenuItem<String>(
                        value: network.ssid,
                        child: Text(network.ssid),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      if (value != null) {
                        controller.selectedNetwork.value = value;
                        await controller.connectToSwitchAP(controller.selectedNetwork.value);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Configure Switch"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  decoration: InputDecoration(labelText: "Switch SSID"),
                                  onChanged: (value) => controller.switchSSID.value = value,
                                ),
                                TextField(
                                  decoration: InputDecoration(labelText: "Switch Password"),
                                  onChanged: (value) => controller.switchPassword.value = value,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await controller.sendConfigurationData();
                                  await controller.reconnectToMainSystemAP();
                                },
                                child: Text("Submit"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}