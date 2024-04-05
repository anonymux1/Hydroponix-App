import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:Hydroponix/models/SystemsList.dart';
import '../models/System.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class provisioningController extends GetxController {
  Rx<SystemsList> systemsList = Rx(
      SystemsList(systems: [])); // Rx for reactivity
  final isLoading = false.obs;
  final isProvisioned = false.obs;
  final isSaved = false.obs;
  final error = ''.obs;
  var systemId;

  Future<void> generateSystemId() async {
    var uuid = Uuid();
    systemId = uuid.v4();
    System newSystem = System(systemId: systemId);
    systemsList.value.systems?.add(newSystem); // Add new system to the list
    systemsList.refresh(); // Update UI
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

  Future<void> sendCredentials(String Name,
      String ssid,
      String password,) async {
    final systemId = systemsList.value.systems?.last.systemId; // Assuming newest system
    systemsList.value.systems?.last.Name = Name;
    systemsList.value.systems?.last.ssid = ssid;
    systemsList.value.systems?.last.password = password;

    final payload = jsonEncode({
      'ssid': ssid,
      'password': password,
      'userId': await _getUserId(),
      'systemId': systemId,
    });
    try {
      isLoading(true);
      // Construct API endpoint URL using ESP8266 IP address
      final url = Uri.http('192.168.1.1', '/provision');
      // Create payload
      // Send request (using http package)
      final response = await http.post(url, body: payload);

      if (response.statusCode == 200) {
        // Handle successful provisioning
        isProvisioned(true);
        await _saveToFirestore(); // Save to Firestore

      } else {
        error.value = 'Something went wrong. Please try again.';
      }
    } on HttpException { // Catch HTTP errors specifically
      error.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading(false);
  }
}

  }
