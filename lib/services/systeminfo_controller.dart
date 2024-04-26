import 'package:Hydroponix/models/SystemList.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:Hydroponix/models/System.dart';

class SystemInfoController extends GetxController {
  SystemList? systemList;
  final isSaved = false.obs;
  System? newSystem;

  Future<void> updateSystemInfo(
      SystemList? userSystems, Map<String, dynamic> parsedData) async {
    try {
      var uuid = Uuid();
      var systemId = uuid.v4();
      var length = userSystems?.getSystemList()?.length;
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

  // Future<String> _getUserId() async {
  //   // Retrieve the userId from Firebase Authentication
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     return user.uid;
  //   } else {
  //     throw Exception('User not signed in'); // Handle this appropriately
  //   }
  // }

  // Future<void> _saveToFirestore(System system) async {
  //   final userId = await _getUserId();
  //   final firestore = FirebaseFirestore.instance;
  //   await firestore.collection(userId).doc('userSystems').set(
  //       {'systems': system},
  //       SetOptions(merge: true)); // Merge with existing data
  //   isSaved(true); // Update status in controller
  // }
}
