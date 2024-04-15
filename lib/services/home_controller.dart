import 'package:Hydroponix/models/systemLogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/System.dart';
import 'package:get/get.dart';
import 'db_helper.dart';

class HomeController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  RxList<System>? userSystems;
  RxList<SystemLog>? systemLogs; // Use RxList for reactivity

  @override
  void onInit() {
    super.onInit();
    fetchDataOnStartup();
  }

  Future<void> fetchDataOnStartup() async {
   userSystems =   await _fetchUserSystems() as RxList<System>?;
    await _fetchLatestSystemLogs();
  }

  Future<void> _fetchUserSystems() async {
    final existingSystemsQuery = firestore.collection('${await _getUserId()}/systems/systemList'); // Filter by user as well
    final querySnapshot = await existingSystemsQuery.get();
    if (querySnapshot.docs.isNotEmpty) {
      //Update Db
      final systems = docs.dat=;
      await _saveSystemsToDatabase(systems.cast<System>());
      userSystems = systems.obs as RxList<System>?; // Update, making it an RxList<System>
    }
  }

  // List<String> _systemsFromFirestore(QuerySnapshot querySnapshot) {
  //   return querySnapshot.docs.map((doc) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     return String(
  //       systemId:  data['systemId'],
  //     );
  //   }).toList();
  // }
  bool listsEqual(List<dynamic> list1, List<dynamic> list2) {
    // Check if both lists have the same length
    if (list1.length != list2.length) {
      return false;
    }
    // Check if all elements in list1 are present in list2
    for (final element in list1) {
      if (!list2.contains(element)) {
        return false;
      }
    }
    // All elements match
    return true;
  }
  Future<void> _saveSystemsToDatabase(List<System> systems) async {
    final dbHelper = DatabaseHelper.instance;
    for (final system in systems) {
      final existingRecord = await dbHelper.queryRow('systems_list', where: 'id = ?', whereArgs: [system.systemId]);
      if (existingRecord != null) {
        bool shouldUpdateSystem = false;
        if(existingRecord["Name"] != system.Name || existingRecord["version"] != system.version || existingRecord["switches"] != system.switches || existingRecord["heavySwitches"] != system.heavySwitches || existingRecord["peristalticPumpsCount"] != system.peristalticPumpsCount) {
          shouldUpdateSystem = true;
        } else {
          final existingModules = await dbHelper.queryColumn('systems_modules', 'moduleType', where: 'systemId =?', whereArgs: [system.systemId]);
          if (!listsEqual(system.modules as List, existingModules))
            shouldUpdateSystem = true;
          final existingSensors = await dbHelper.queryColumn('systems_sensors', 'sensorType', where: 'systemId =?', whereArgs: [system.systemId]);
          if (!listsEqual(system.sensors as List, existingSensors))
            shouldUpdateSystem = true;
          final existingConfig = await dbHelper.queryRow('systems_config', where: 'systemId = ?', whereArgs: [system.systemId]);

          }
          }
        }
        // System exists: Check if it needs an update (you'll need logic for this)
      //   if (shouldUpdateSystem) {
      //     await dbHelper.updateSystem(system); // Update if needed
      //   }
      // } else {
      //   // New system: Insert
      //   await dbHelper.insertSystem(system);
      // }
    }
  }

  Future<void> _fetchLatestSystemLogs() async {
    if (userSystems?.value.systems == null) return;
    systemLogs = RxList<SystemLog>();
    for (final system in userSystems!.value.systems!) {
      final lastUpdateTimestamp =When home_
          await _getLastUpdateTimestamp(system.systemId);
      final query = firestore
          .collection(
              'users/${await _getUserId()}/systems/${system.systemId}/logs')
          .where('timestamp', isGreaterThan: lastUpdateTimestamp)
          .orderBy('timestamp');
      final snapshot = await query.get();
      systemLogs!.addAll(
          snapshot.docs.map((doc) => SystemLog.fromJson(doc.data())).toList());
      // ... Logic to update lastUpdateTimestamp in SharedPreferences
      if (snapshot.docs.isNotEmpty) {
        // Only update if new logs were fetched
        final prefs = await SharedPreferences.getInstance();
        final lastLog = snapshot.docs.last; // Get the most recent log
        final lastTimestamp = lastLog.get('timestamp')
            as Timestamp; // Assuming 'timestamp' is a Firestore Timestamp field
        prefs.setString(
            'lastUpdate_${system.systemId}', lastTimestamp.toDate().toString());
        prefs.setStringList('logs_${system.systemId}',
            snapshot.docs.map((doc) => jsonEncode(doc.data())).toList());
      }
    }
  }

  Future<Timestamp?> _getLastUpdateTimestamp(int? systemId) async {
    final prefs = await SharedPreferences.getInstance();
    final lastTimestampStr = prefs.getString('lastUpdate_$systemId');
    if (lastTimestampStr != null) {
      return Timestamp.fromDate(DateTime.parse(lastTimestampStr));
    }
    return null;
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

  bool shouldUpdateSystem(System system, id) {
    final dbHelper = DatabaseHelper.instance;

  }
}
