import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:Hydroponix/models/systemLogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/SystemList.dart';
import 'package:Hydroponix/services/db_helper.dart';

import '../models/systemLogsList.dart';

class HomeController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  // final db = DatabaseHelper.instance;
  SystemList? userSystems;
  List<SystemLogList>? systemsLogs; // Use RxList for reactivity

  @override
  void onInit() {
    super.onInit();
    fetchDataOnStartup();
  }

  Future<void> fetchDataOnStartup() async {
   _fetchUserSystems();
   _fetchLatestSystemLogs();
  }

  Future<void> _fetchUserSystems() async {
    final docRef = firestore.collection('${await _getUserId()}').doc("systemList");
    docRef.get().then(
          (DocumentSnapshot doc) async {
            userSystems = doc.data() as SystemList;
          },
      onError: (e) => print("Error getting document: $e"),
    );
  }
  // List<String> _systemsFromFirestore(QuerySnapshot querySnapshot) {
  //   return querySnapshot.docs.map((doc) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     return String(
  //       systemId:  data['systemId'],
  //     );
  //   }).toList();
  // }
  // bool listsEqual(List<dynamic> list1, List<dynamic> list2) {
  //   // Check if both lists have the same length
  //   if (list1.length != list2.length) {
  //     return false;
  //   }
  //   // Check if all elements in list1 are present in list2
  //   for (final element in list1) {
  //     if (!list2.contains(element)) {
  //       return false;
  //     }
  //   }
  //   // All elements match
  //   return true;
  // Future<void> _saveSystemsToDatabase(List<System> systems) async {
  //   final dbHelper = DatabaseHelper.instance;
  //   for (final system in systems) {
  //     final existingRecord = await dbHelper.queryRow('systems_list', where: 'id = ?', whereArgs: [system.systemId]);
  //     if (existingRecord != null) {
  //       bool shouldUpdateSystem = false;
  //       if(existingRecord["Name"] != system.Name || existingRecord["version"] != system.version || existingRecord["switches"] != system.switches || existingRecord["heavySwitches"] != system.heavySwitches || existingRecord["peristalticPumpsCount"] != system.peristalticPumpsCount) {
  //         shouldUpdateSystem = true;
  //       } else {
  //         final existingModules = await dbHelper.queryColumn('systems_modules', 'moduleType', where: 'systemId =?', whereArgs: [system.systemId]);
  //         if (!listsEqual(system.modules as List, existingModules))
  //           shouldUpdateSystem = true;
  //         final existingSensors = await dbHelper.queryColumn('systems_sensors', 'sensorType', where: 'systemId =?', whereArgs: [system.systemId]);
  //         if (!listsEqual(system.sensors as List, existingSensors))
  //           shouldUpdateSystem = true;
  //         final existingConfig = await dbHelper.queryRow('systems_config', where: 'systemId = ?', whereArgs: [system.systemId]);
  //
  //         }
  //         }
  //       }
  //
  //   }
  // }

  Future<void> _fetchLatestSystemLogs() async {
    if (userSystems?.systemList == null) return;
    if (userSystems?.systemList != null) {
      for (final system in userSystems!.systemList!) {
        int index = 0;
        final docRef = firestore.collection('${await _getUserId()}').doc('${system.systemId}');
        docRef.get().then(
                (DocumentSnapshot doc) async {
              systemsLogs?[index] = doc.data() as SystemLogList;

        // final lastUpdateTimestamp =
        // await _getLastUpdateTimestamp(system.systemId);
        // final query = firestore
        //     .collection(
        //     '${await _getUserId()}/${system.systemId}/');
        // final snapshot = await query.get();
        // systemLogs!.addAll(snapshot.docs.map((doc) => SystemLog.fromJson(doc.data())).toList());
        // if (snapshot.docs.isNotEmpty) {
        //   systemLogs = snapshot.docs.data()
        //   // Only update if new logs were fetched
          // final lastLog = snapshot.docs.last; // Get the most recent log
          // final lastTimestamp = lastLog.get('timestamp')
          // as Timestamp; // Assuming 'timestamp' is a Firestore Timestamp field
          // db.insertRow(systemLogs, row)

        });
        index++;
      }
    }
  }

  // Future<Timestamp?> _getLastUpdateTimestamp(String? systemId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final lastTimestampStr = prefs.getString('lastUpdate_$systemId');
  //   if (lastTimestampStr != null) {
  //     return Timestamp.fromDate(DateTime.parse(lastTimestampStr));
  //   }
  //   return null;
  // }

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
