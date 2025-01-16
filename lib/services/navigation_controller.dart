import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/SystemList.dart';
import 'package:Hydroponix/models/SystemLogs.dart';
import 'mqtt_provider.dart';

class NavigationController extends GetxController {
  final _currentPageIndex = 0.obs;
  int get currentPageIndex => _currentPageIndex.value;
  final profilePhotoUrl = RxString(''); // Reactive profile photo URL
  final firestore = FirebaseFirestore.instance;
  SystemList? userSystemList;
  Map<String, List<SystemLog>>? allSysLogs = {}; // Should this be a Map<String, List<SystemLog>> sysLogs? Map Entry- systemId, List<logs>
  Map<String, List<SystemLog>>? latestReadings = {};
  var fetchingSystems = true.obs;
  var isLoading = true.obs;
  MQTTClientWrapper newClient = new MQTTClientWrapper();

  @override
  void onInit() {
    super.onInit();
    _fetchUserSystems();
    newClient.prepareMqttClient();
  }

  Future<void> _fetchUserSystems() async {
    try {
      final docRef =
        await firestore.collection('${await _getUserId()}').doc("systemList");
    final doc = await docRef.get();
    if (doc.exists) {
            userSystemList =
                SystemList.fromFirestore(doc.data() as Map<String, dynamic>);
            await _fetchLatestSystemLogs();
          }
    else  {      log("No system list found for the user.");
    }
  } catch (e) {
  log("Error fetching systems: $e");
  } finally {
  fetchingSystems.value = false; // Indicate fetching is complete
  }
}


  Future<void> _fetchLatestSystemLogs() async {
    log("FetchLogs function called");
    if (userSystemList == null) {
      log("fetchLatestLogs: No User Systems");
      fetchingSystems.value = false;
      return;
    }
    List<Future<void>> futures = [];
    for (final system in userSystemList!.systemList!) {
        final docRef = firestore
            .collection('${await _getUserId()}')
            .doc('${system.systemId}');
        futures.add(docRef.get().then((DocumentSnapshot doc) async {
          List list = (doc.data() as Map<String, dynamic>?)?['Logs'] ?? [];
           log("navController logslist:" + list.toString());
          final syslog = list.map((e) => e as Map<String, dynamic>).toList();
          for (Map<String, dynamic> i in syslog) {
            log(i.toString());
            SystemLog logline = SystemLog.fromJson(i);
              List<SystemLog>? temp = allSysLogs?[system.systemId]??[];
              temp.add(logline);
              allSysLogs?.update(system.systemId!, (value) => temp, ifAbsent: () => temp);
              log("navcontroller allSysLogs: ${allSysLogs.toString()}");
            if (latestReadings == null) {
              latestReadings = {};
            }
            List<SystemLog> tmp = latestReadings![system.systemId] ?? [];
            bool updated = false;
            for (int idx = 0; idx < tmp.length; idx++) {
              if(tmp[idx].eventType == logline.eventType) {
                if (tmp[idx].timestamp.compareTo(logline.timestamp) < 0) {
                  tmp[idx] = logline;
                  updated = true;
                  break; // Exit loop after updating
                }
              }
            }
            if (!updated) {
              tmp.add(logline); // Add new entry if not updated
            }
            latestReadings![system.systemId!] = tmp; // Direct assignment
          }
          log("navcontroller allSysLogs: ${allSysLogs.toString()}");
          log("navcontroller latestReadings: ${latestReadings.toString()}");
        }));
      }
      await Future.wait(futures);
      fetchingSystems.value = false;
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

  void changePageIndex(int newIndex) {
    _currentPageIndex.value = newIndex;
  }
}
