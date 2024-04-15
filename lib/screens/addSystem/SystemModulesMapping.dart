import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Or your preferred state management
import 'package:http/http.dart' as http; // For API
import 'package:Hydroponix/services/systeminfo_controller.dart';
import 'package:Hydroponix/screens/addSystem/SystemInfo.dart';

import '../../services/systemmodulesmapping_controller.dart';

class SystemModulesMappingScreen extends StatefulWidget {
final String? systemId;
  const SystemModulesMappingScreen(this.systemId, {Key? key}) : super(key: key); // Constructor

  @override
  _SystemModulesMappingScreenState createState() =>
      _SystemModulesMappingScreenState();
}

class _SystemModulesMappingScreenState
    extends State<SystemModulesMappingScreen> {
  final SystemModulesMappingController systemModulesMappingController = Get.find();
  Map<int, String> moduleMappings = {}; // To store switch-module relationships

  @override
  void initState() {
    super.initState();
    _fetchModuleMappings(); // Potentially fetch mappings based on systemId
    _startMappingProcess(); // Check on initialization and show dialog if needed
  }

  Future<void> _fetchModuleMappings() async {
    if (widget.systemId != null) { // Check if systemId is not null
      final querySnapshot = await FirebaseFirestore.instance
          .collection('moduleMappings')
          .where('systemId', isEqualTo: widget.systemId)
          .get();

      setState(() {
        moduleMappings = querySnapshot.docs.fold<Map<int, String>>(
            {}, (map, doc) =>
        map
          ..putIfAbsent(doc['switchNumber'], () => doc['moduleName']));
      });
    }
  }

  Future<void> _startMappingProcess() async {
    if (systemModulesMappingController.systemsList.value.systems?.last.version == 'HOBBY') {
      await _mapHobbyModules();
    } else if (systemModulesMappingController.systemsList.value.systems?.last.version == 'PRO') {
      await _mapProModules();
    } else  if (systemModulesMappingController.systemsList.value.systems?.last.version == null || (systemInfoController.systemsList.value.systems?.last.version != 'HOBBY' && systemInfoController.systemsList.value.systems?.last.version != 'PRO')) {
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
