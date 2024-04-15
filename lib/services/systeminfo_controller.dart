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
  final isSaved = false.obs;

  Future<void> updateSystemInfo(Map<String, dynamic> parsedData) async {
    try {
      var uuid = Uuid();
      var systemId = uuid.v4();
      final existingSystemsQuery = firestore
          .collection('${await _getUserId()}/SystemsList');
      final querySnapshot = await existingSystemsQuery.get();
      if (querySnapshot.docs.isNotEmpty) {
        // Handle existing system with the same ID (e.g., error, update existing)
      } else {
        System newSystem = System(systemId: systemId);
        systemsList.value.systems?.add(newSystem); // Add new system to the list
        systemsList.refresh(); // Update UI
        _saveToFirestore(systemList);
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

  Future<void> _saveToFirestore() async {
    final userId = await _getUserId();
    final firestore = FirebaseFirestore.instance;
    // Get the newest system (assuming the one just added)
    final newSystem = systemsList.value.systems?.last;
    if (newSystem != null) {
      await firestore.collection('userSystems').doc(userId).set({
        'systems': FieldValue.arrayUnion([newSystem.toJson()])
      }, SetOptions(merge: true)); // Merge with existing data
      isSaved(true); // Update status in controller
    } else {
      // Handle the unlikely case of newSystem being null (logging or error handling)
    }
  }
}
