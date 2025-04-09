import 'package:Hydroponix/models/SystemList.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:Hydroponix/models/System.dart';
import 'dart:async';


class SystemInfoController extends GetxController {
  SystemList? systemList;
  final isSaved = false.obs;
  System? newSystem;
  final error = ''.obs;


  Future<void> updateSystemInfo(SystemList? userSystems,
      Map<String, dynamic> parsedData) async {
    try {
      var uuid = Uuid();
      var systemId = uuid.v4();
      var length = userSystems
          ?.getSystemList()
          ?.length;
      for (int idx = 0; idx <= length!; idx++) {
        if (userSystems?.getSystemList()?[idx].systemId == systemId)
          systemId = uuid.v4();
      }
      newSystem?.systemId = systemId;
      newSystem?.version = parsedData['version'];
      newSystem?.switches = parsedData['switches'];
      newSystem?.heavySwitches = parsedData['heavySwitches'];
      newSystem?.sensors = parsedData['sensors'];
      userSystems?.systemList?.add(newSystem!);
      systemList = userSystems;
      //   _saveToFirestore(newSystem!);
    } catch (error) {
      // Handle errors here (e.g., show error messages)
      print("Firestore Update Error: $error");
    }
  }
}


