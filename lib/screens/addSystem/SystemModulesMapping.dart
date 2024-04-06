import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Or your preferred state management
import 'package:http/http.dart' as http; // For API
import 'package:Hydroponix/services/systeminfo_controller.dart';
import 'package:Hydroponix/screens/addSystem/SystemInfo.dart';

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
    if (systemInfoController.systemsList.value.systems?.last.version == 'HOBBY') {
      await _mapHobbyModules();
    } else if (systemInfoController.systemsList.value.systems?.last.version == 'PRO') {
      await _mapProModules();
    } else  if (systemInfoController.systemsList.value.systems?.last.version == null || (systemInfoController.systemsList.value.systems?.last.version != 'HOBBY' && systemInfoController.systemsList.value.systems?.last.version != 'PRO')) {
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
                Get.to(() => SystemInfoScreen());
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
    final switches = systemInfoController.systemsList.value.systems?.last.switches ?? 0;
    var modulesList = systemInfoController.systemsList.value.systems?.last.modules;
    for (int switchIndex = 0; switchIndex < switches; switchIndex++) {
        await _controlSwitch(switchIndex, true);
      }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
