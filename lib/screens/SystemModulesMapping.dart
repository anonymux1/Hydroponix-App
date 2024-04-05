import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Or your preferred state management
import 'package:http/http.dart' as http; // For API
import 'package:Hydroponix/services/systems_controller.dart';
import 'package:Hydroponix/screens/SystemVersion.dart';

class SystemModulesMappingScreen extends StatefulWidget {
  @override
  _SystemModulesMappingScreenState createState() =>
      _SystemModulesMappingScreenState();
}

class _SystemModulesMappingScreenState
    extends State<SystemModulesMappingScreen> {
  final SystemInfoController systemInfoController = Get.find();
  Map<int, String> moduleMappings = {}; // To store switch-module relationships

  @override
  void initState() {
    super.initState();
    _startMappingProcess(); // Check on initialization and show dialog if needed
  }

  Future<void> _startMappingProcess() async {
    if (systemInfoController.systemInfo.value?.version == 'HOBBY') {
      await _mapHobbyModules();
    } else if (systemInfoController.systemInfo.value?.version == 'PRO') {
      await _mapProModules();
    } else  if (systemInfoController.systemInfo.value?.version == null || (systemInfoController.systemInfo.value?.version != 'HOBBY' && systemInfoController.systemInfo.value?.version != 'PRO')) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Something Went Wrong.Need to re-check system version'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Get.to(() => SystemVersionScreen());
              },
              child: const Text('RECHECK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _controlSwitch(int? switchIndex, bool state) async {
    final url = Uri.http('192.168.1.1', '/control',
        {'switch': '$switchIndex', 'state': '$state'});
    await http.post(url);
  }

  Future<void> _mapHobbyModules() async {
  //  int switchIndex = 0;
  //  for (; switchIndex < systemInfoController.systemInfo!.switches.length - 1 ; switchIndex++) {
      // 1. Control Switch
      await _controlSwitch(0, true);
      final moduleType = await showDialog<String>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('Identify Module'),
              content: const Text('Which Pump turned ON?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Water Pump'),
                  child: const Text('Water Pump'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Air Pump'),
                  child: const Text('Air Pump'),
                ),
              ],
            ),
      );
      if (moduleType != null || await Future.delayed(const Duration(seconds: 5)))
        await _controlSwitch(0, false);
        if (moduleType != null)
        moduleMappings[0] = moduleType;
        if (moduleType == 'Air Pump')
          moduleMappings[1] = 'Water Pump';
        else if(moduleType == 'Water Pump')
          moduleMappings[1] = 'Air Pump';
  }

  Future<void> _mapProModules() async {
    // Implementation in next step
    final lightDutySwitches = systemInfoController.systemInfo.value!.lightDutySwitches ?? 0;
    for (int switchIndex = 0; switchIndex < lightDutySwitches; switchIndex++) {
        await _controlSwitch(switchIndex, true);

      }
    final heavy = systemInfoController.systemInfo.value!.heavyDutySwitches ?? 0;
      for (int switchIndex = 0; switchIndex < heavy; switchIndex++) {

      }
  }



  Widget build(BuildContext context) {
    final systemInfo = systemInfoController.systemInfo;
    // Switch UI based on version
    if (systemInfo.value?.version == 'HOBBY') {
      return _buildHobbyUI(); // Function to create UI for Mapping version
    } else if (systemInfo.value?.version == 'PRO') {
      return _buildProUI(); // Function to create UI for Pro version
    } else {
      return const Center(child: Text('Unknown System Version'));
    }
  }

  Widget _buildHobbyUI() {


  }

  Widget _buildProUI() {
    // ... Create UI elements specific to Pro version ...
  }


}
