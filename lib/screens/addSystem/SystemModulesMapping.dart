import 'package:Hydroponix/screens/addSystem/SystemProvisioning.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Or your preferred state management
import 'package:Hydroponix/screens/addSystem/SystemInfo.dart';
import '../../models/SystemList.dart';
import '../../services/systemmodulesmapping_controller.dart';
import 'SystemAddWifiSwitches.dart';

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
  bool isMappingComplete = false;

  @override
  void initState() {
    super.initState();
    // _fetchModuleMappings(); // Potentially fetch mappings based on systemId
    _startMappingProcess(); // Check on initialization and show dialog if needed
  }

  Future<void> _startMappingProcess() async {
    var length = widget.userSystems?.getSystemList()?.length;
    if (widget.userSystems?.getSystemList()?[length!].version == 'HOBBY') {
      await systemModulesMappingController.mapHobbyModules(widget.userSystems);
    } else if (widget.userSystems?.getSystemList()?[length!].version == 'PRO') {
      await systemModulesMappingController.mapProModules(widget.userSystems, _modulesList, selectedItem, _updateUI);
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
    isMappingComplete = true;
    setState(() {});
  }


  void _updateUI() {
    setState(() {});
  }

    Widget _buildBody() {
      var length = widget.userSystems?.getSystemList()?.length;
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: (widget.userSystems?.getSystemList()?[length!].modules?.length ?? 0) + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: Text("Detected Version: ${widget.userSystems?.getSystemList()?[length!].version}"),
                    subtitle: Text("Number of Switches: ${widget.userSystems?.getSystemList()?[length!].switches}"),
                  );
                } else if (index < (widget.userSystems?.getSystemList()?[length!].modules?.length ?? 0) + 1) {
                  var moduleName = widget.userSystems?.getSystemList()?[length!].modules?.keys.elementAt(index - 1);
                  var switchNumber = widget.userSystems?.getSystemList()?[length!].modules?.values.elementAt(index - 1);
                  return ListTile(
                    title: Text(moduleName!),
                    subtitle: Text("Switch Number: $switchNumber"),
                  );
                } else {
                  return ListTile(
                    title: Text("Press Next to Confirm or Back to Reconfigure"),
                  );
                }
              },
            ),
          ),
          TextButton(
            onPressed: () async {
              bool? pairWifiSwitches = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Pair Wi-Fi Switches'),
                  content: const Text('Do you want to pair any Wi-Fi switches?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
              if (pairWifiSwitches == true) {
                Get.to(() => SystemAddWifiSwitchesScreen(widget.userSystems));
              } else {
                Get.to(() => SystemProvisioningScreen(widget.userSystems));
              }
            },
            child: const Text('NEXT'),
          ),
          TextButton(
            onPressed: _startMappingProcess,
            child: const Text('BACK'),
          ),
        ],
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("System Information")),
      body: _buildBody(),
    );
  }
}
