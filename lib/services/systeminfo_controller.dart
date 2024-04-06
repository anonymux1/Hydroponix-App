import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/System.dart';
import 'package:Hydroponix/models/SystemsList.dart';

class SystemInfoController extends GetxController {
  Rx<SystemsList> systemsList =
      Rx(SystemsList(systems: [])); // Rx for reactivity
  final firestore = FirebaseFirestore.instance;

  Future<void> updateSystemInfo(Map<String, dynamic> parsedData) async {
    try {
      var uuid = Uuid();
      var systemId = uuid.v4();
      final existingSystemsQuery = firestore
          .collection('userSystems')
          .where('systemId', isEqualTo: systemId)
          .where('userId',
              isEqualTo: await _getUserId()); // Filter by user as well
      final querySnapshot = await existingSystemsQuery.get();
      if (querySnapshot.docs.isNotEmpty) {
        // Handle existing system with the same ID (e.g., error, update existing)
      } else {
        System newSystem = System(systemId: systemId);
        systemsList.value.systems?.add(newSystem); // Add new system to the list
        systemsList.refresh(); // Update UI
      }
    } catch (error) {
      // Handle errors here (e.g., show error messages)
      print("Firestore Update Error: $error");
    }
  }

  Future<String> _getUserId() async {
    // Retrieve the userId from Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User not signed in'); // Handle this appropriately
    }
  }
}
