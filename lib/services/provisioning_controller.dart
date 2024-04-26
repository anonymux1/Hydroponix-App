import 'dart:io';
import 'package:Hydroponix/models/SystemList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/System.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class provisioningController extends GetxController {
  SystemList? systemsList;
  final isLoading = false.obs;
  final isProvisioned = false.obs;
  final isSaved = false.obs;
  final error = ''.obs;
  var systemId;

  Future<String> _getUserId() async {
    // Retrieve the userId from Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User not signed in'); // Handle this appropriately
    }
  }

  Future<void> _saveToFirestore(System? newSystem) async {
    final userId = await _getUserId();
    final firestore = FirebaseFirestore.instance;
    // Get the newest system (assuming the one just added)
    if (newSystem != null) {
      await firestore.collection(userId).doc('SystemsList').set({
        'systems': FieldValue.arrayUnion([newSystem])
      }, SetOptions(merge: true)); // Merge with existing data
      isSaved(true); // Update status in controller
    } else {
      // Handle the unlikely case of newSystem being null (logging or error handling)
    }
  }

  Future<void> setCredentials(
      SystemList? userSystems,
      String Name,
      String ssid,
      String pwd,
      String airPumpDuration,
      String airPumpInt,
      String waterPumpDuration,
      String waterPumpInt) async {
    var length = userSystems?.getSystemList()?.length;
    userSystems?.getSystemList()?[length!].Name = Name;
    userSystems?.getSystemList()?[length!].ssid = ssid;
    userSystems?.getSystemList()?[length!].password = pwd;
    userSystems?.getSystemList()?[length!].airPumpInterval = airPumpInt as int?;
    userSystems?.getSystemList()?[length!].airPumpDuration = airPumpDuration as int?;
    userSystems?.getSystemList()?[length!].waterPumpInterval = waterPumpInt as int?;
    userSystems?.getSystemList()?[length!].waterPumpDuration = waterPumpDuration as int?;

    final payload = jsonEncode({
      'ssid': userSystems?.getSystemList()?[length!].ssid,
      'password': userSystems?.getSystemList()?[length!].password,
      'userId': await _getUserId(),
      'systemId': userSystems?.getSystemList()?[length!].systemId,
      'airPumpInterval': userSystems?.getSystemList()?[length!].airPumpInterval,
      'airPumpDuration': userSystems?.getSystemList()?[length!].airPumpDuration,
      'waterPumpInterval': userSystems?.getSystemList()?[length!].waterPumpInterval,
      'waterPumpDuration': userSystems?.getSystemList()?[length!].waterPumpDuration,
      'nutrientTempMin': userSystems?.getSystemList()?[length!].nutrientTempMin,
      'nutrientTempMax': userSystems?.getSystemList()?[length!].nutrientTempMax,
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
        await _saveToFirestore(userSystems?.getSystemList()?[length!]); // Save to Firestore
      } else {
        error.value = 'Something went wrong. Please try again.';
      }
    } on HttpException {
      // Catch HTTP errors specifically
      error.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading(false);
    }
  }
}
