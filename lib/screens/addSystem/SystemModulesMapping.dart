import 'package:Hydroponix/screens/addSystem/SystemProvisioning.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Or your preferred state management
import 'package:http/http.dart' as http; // For API
import 'package:Hydroponix/screens/addSystem/SystemInfo.dart';
import '../../models/SystemList.dart';
import '../../services/systemmodulesmapping_controller.dart';

class SystemModulesMappingScreen extends StatefulWidget {
  final SystemList? userSystems;
  const SystemModulesMappingScreen(this.userSystems, {Key? key})
      : super(key: key); // Constructor

  @override
  _SystemModulesMappingScreenState createState() =>
      _SystemModulesMappingScreenState();
}

class _SystemModulesMappingScreenState
    extends State<SystemModulesMappingScreen> {
  final SystemModulesMappingController systemModulesMappingController =
      Get.find();
  static const List<String> _modulesList = [
    'Air Pump',
    'Water Pump',
    'Nutrient Chiller',
    'Nutrient Heater',
    'Desert Air Cooler',
    'Humidifier',
    'Air Conditioner',
    'LED Light Strip',
    'UV Sterilizer'
  ];
  String? selectedItem = 'Air Pump';

  @override
  void initState() {
    super.initState();
    // _fetchModuleMappings(); // Potentially fetch mappings based on systemId
    _startMappingProcess(); // Check on initialization and show dialog if needed
  }

  Future<void> _startMappingProcess() async {
    var length = widget.userSystems?.getSystemList()?.length;
    if (widget.userSystems?.getSystemList()?[length!].version == 'HOBBY') {
      await _mapHobbyModules();
    } else if (widget.userSystems?.getSystemList()?[length!].version == 'PRO') {
      await _mapProModules();
    } else if (widget.userSystems?.getSystemList()?[length!].version == null ||
        (widget.userSystems?.getSystemList()?[length!].version != 'HOBBY' &&
            widget.userSystems?.getSystemList()?[length!].version != 'PRO')) {
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
                Get.to(() => SystemInfoScreen(widget.userSystems));
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
    final moduleTypeAlert = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Identify Pump'),
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
    var length = widget.userSystems?.getSystemList()?.length;
    if (moduleTypeAlert != null ||
        await Future.delayed(const Duration(seconds: 5)))
      await _controlSwitch(0, false);
    if (moduleTypeAlert == 'Air Pump')
      widget.userSystems?.getSystemList()?[length!].modules = {
        'Air Pump': 0,
        'Water Pump': 1
      };
    else if (moduleTypeAlert == 'Water Pump')
      widget.userSystems?.getSystemList()?[length!].modules = {
        'Water Pump': 0,
        'Air Pump': 1
      };
  }

  Future<void> _mapProModules() async {
    // Implementation in next step
    var length = widget.userSystems
        ?.getSystemList()
        ?.length;
    final switches =
        widget.userSystems?.getSystemList()?[length!].switches ?? 0;
    final heavySwitches =
        widget.userSystems?.getSystemList()?[length!].heavySwitches ?? 0;
    for (int switchIndex = 0;
    switchIndex < (switches + heavySwitches);
    switchIndex++) {
      await _controlSwitch(switchIndex, true);
      final moduleTypeAlert = await showDialog<String>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('Select Module that turned ON'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedItem,
                    items: _modulesList.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // Use a nullable type for onChanged
                      if (newValue != null) {
                        selectedItem = newValue;
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, selectedItem),
                  child: const Text('Add More Modules'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Done'),
                ),
              ],
            ),
      );
      if (moduleTypeAlert != null ||
          await Future.delayed(const Duration(seconds: 5))) {
        var module;
        module.addAll(selectedItem, switchIndex);
        widget.userSystems
            ?.getSystemList()?[length!]
            .modules
            ?.addEntries(module);
      }
    }
  }

    Widget _buildBody() {
      var length = widget.userSystems?.getSystemList()?.length;
      return Column(children: [
        Expanded(
          child: ListView.builder(
              itemCount:
              widget.userSystems?.getSystemList()?[length!].modules?.length ?? 0,
              itemBuilder: (context, index) {
                var ModuleName = widget.userSystems
                    ?.getSystemList()?[length!]
                    .modules?[index]
                    .toString();
                List<Widget> widgets = [
                  ListTile(
                    title: Text(ModuleName!),
                  ),
                ];
                TextButton(
                  onPressed: () => Get.to(SystemProvisioningScreen(widget.userSystems)),
                  child: const Text('NEXT'),
                );
                return Column(
                    children: widgets); // Return the widgets within a Column
              }),
        )
      ]);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("System Information")),
      body: _buildBody(),
    );
  }
}
