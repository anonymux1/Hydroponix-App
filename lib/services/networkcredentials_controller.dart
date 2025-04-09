import 'package:Hydroponix/models/SystemList.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NetworkCredentialsController extends GetxController {
  SystemList? systemList;
  final error = ''.obs;

  Future<List<DropdownMenuItem<String>>?>? getNetworks() async {
    try {
      final url = Uri.http('192.168.1.1', '/getNetworks');
      final response = await http.post(url, body: "");
      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);
        final ssids = (parsedData["Networks"]
        as List<dynamic>).map((ssid) => ssid as String).toList();
        List<DropdownMenuItem<String>> dropdownMenuItems = ssids.map((ssid) {
          return DropdownMenuItem<String>(
            value: ssid,
            child: Text(ssid),
          );
        }).toList();
        return dropdownMenuItems;
      }
    } on HttpException {
      // Catch HTTP errors specifically
      error.value = 'Something went wrong. Please try again.';
    }
    return null;
  }

  Future<void> saveNetworkCredentials(SystemList? userSystems, String ssid,
      String password, bool use2g) async {
    try {
      var length = userSystems
          ?.getSystemList()
          ?.length;
      userSystems?.getSystemList()?[length!].ssid = ssid;
      userSystems?.getSystemList()?[length!].password = password;
      userSystems?.getSystemList()?[length!].use2G = use2g;
      systemList = userSystems;
    } catch (error) {
      // Handle errors here (e.g., show error messages)
      print("Error saving network credentials: $error");
    }
  }
}