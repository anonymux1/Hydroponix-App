import 'package:get/get.dart';
import '../models/System.dart';
import 'package:Hydroponix/models/SystemsList.dart';

class SystemInfoController extends GetxController {
  Rx<System?> systemInfo = Rx(null); // Use Rx to make systemInfo observable

  void updateSystemInfo(System info) {
    systemInfo.value = info; // Update the Rx object
  }
}

