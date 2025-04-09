import 'dart:io';
import 'package:Hydroponix/models/SystemList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/System.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

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

  Future<void> _saveToFirestore(System? system) async {
      // Get the newest system (assuming the one just added)
    if (system == null)
    return;
    try{
      final userId = await _getUserId();
       await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("systems")
        .doc(system.systemId)
        .set(system.toJson(), SetOptions(merge: true))
        .timeout(const Duration(seconds: 10)); // Timeout for Firestore
      isSaved(true); // Update status in controller
    } on TimeoutException {
      error.value = 'Saving to Firestore timed out. Please try again.';
    } on FirebaseException catch (e) {
    error.value = 'Firestore Error: ${e.message}';
    } catch (e) {
    error.value = 'Unexpected error while saving: $e';
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
    var airPumpSwitch, waterPumpSwitch;
    userSystems?.getSystemList()?[length!].modules?.forEach((moduleName, switchNumber) {
      if (moduleName == "Air Pump")
        airPumpSwitch = switchNumber;
      else if (moduleName == "Water Pump")
        waterPumpSwitch = switchNumber;
    });
    final payload = jsonEncode({       // Create payload
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
      'airPumpSwitch': airPumpSwitch,
      'waterPumpSwitch': waterPumpSwitch,
    });
    try {
      isLoading(true);
      // Construct API endpoint URL using ESP8266 IP address
      final url = Uri.http('192.168.1.1', '/updateConfig');
      // Send request (using http package)
      final response = await http.post(url, body: payload).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        // Handle successful provisioning
        isProvisioned(true);
        await _saveToFirestore(userSystems?.getSystemList()?[length!]); // Save to Firestore
      } else {
        error.value = 'Something went wrong. Please try again.';
      }
    } on TimeoutException {
      error.value = 'Connection timed out. Please check your network and try again.';
    } on HttpException {
      // Catch HTTP errors specifically
      error.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading(false);
    }
  }

  Future<List<DropdownMenuItem<String>>?>? getNetworks() async {
    try {
      final url = Uri.http('192.168.1.1', '/getNetworks');
      final response = await http.post(url, body:"");
      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);
        final ssids = (parsedData["Networks"]
                      as List<dynamic>).map((ssid)
                      => ssid as String).toList();
        List<DropdownMenuItem<String>> dropdownMenuItems = ssids.map((ssid) {
          return DropdownMenuItem<String>(
            value: ssid,
            child: Text(ssid),
          );
        }).toList();
        return dropdownMenuItems;
      }
    }on HttpException {
      // Catch HTTP errors specifically
      error.value = 'Something went wrong. Please try again.';
    }
    return null;
  }
}
