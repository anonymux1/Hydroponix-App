import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/systeminfo_controller.dart';

class SystemModulesSelectionScreen extends StatefulWidget {
  final String? systemId;
  const SystemModulesSelectionScreen(this.systemId, {Key? key}) : super(key: key); // Constructor

  @override
  _SystemModulesSelectionScreenState createState() =>
      _SystemModulesSelectionScreenState();
}

class _SystemModulesSelectionScreenState
    extends State<SystemModulesSelectionScreen> {
  final SystemInfoController systemInfoController = Get.find();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}