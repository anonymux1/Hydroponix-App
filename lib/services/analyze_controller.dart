import 'dart:developer';

import 'package:get/get.dart';
import 'package:Hydroponix/models/SystemList.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import '../models/System.dart';
import '../models/SystemLogs.dart';

class AnalyzeController extends GetxController {

  List<String>? getSystemIdList(SystemList? usersystemList) {
    List<String>? idList = [];
    for (System s in usersystemList!.systemList!) {
      idList.add(s.systemId!);
    }
    return idList;
  }

  String? getSysName(SystemList? usersystemList, String Id) {
    for (System s in usersystemList!.systemList!) {
      if (s.systemId == Id) {
        return s.Name;
      }
    }
    return null;
  }

  List<FlSpot?> getChartData(Map<String, List<SystemLog>>? allSysLogs,
      String? systemId, String dataType) {
    if (systemId == null || allSysLogs == null) {
      return [];
    }
    final logs = allSysLogs[systemId];
    if (logs == null) {
      return [];
    }
    else {
      log(dataType);
      final data = logs.where((log) => log.dataType.toLowerCase().trim() == dataType.toLowerCase().trim())
          .map((log) {
          final timestamp = log.timestamp.millisecondsSinceEpoch.toDouble() /
              1000; // Convert to seconds
          print(timestamp);
          final value = log.eventData.toDouble() ??  0.0;
          print(value);
          return FlSpot(timestamp, value);
      }).toList();
      if (data.isEmpty) {
        return []; // Return an empty list of FlSpot if no matching data
      } else {
        return data;
      }
    }
  }
}