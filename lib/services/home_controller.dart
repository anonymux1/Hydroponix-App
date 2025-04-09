import 'dart:developer';

import 'package:Hydroponix/models/SystemLogs.dart';
import 'package:get/get.dart';
import '../models/System.dart';



class HomeController extends GetxController {
  var isComputing = true.obs;

  String getStringForVariable(String x) {
    switch (x) {
      case 'temp':
        return 'Nutrient Temperature: ';
      case 'ec':
        return 'EC: ';
      case 'ph':
        return 'pH: ';
      case 'ambienttemp':
        return 'Ambient Temperature: ';
      case 'ambienthumidity':
        return 'Ambient Humidity: ';
      case 'airPump':
        return 'Air Pump: ';
      case 'waterPump':
        return 'Water Pump: ';
      default:
        return '';
    }
  }

  String makeStatusString(List<SystemLog>? l) {
    log("homecontroller ${l.toString()}");
    String sensors = "";
    if(l != null) {
      for (SystemLog i in l) {
        if (i.eventType == "sensor")
          sensors += getStringForVariable(i.dataType) + '\t' + i.eventData.toString() + "\n";
      }
      DateTime t = DateTime.now();
      for (SystemLog i in l) {
        if (i.eventType == "module") {
          Duration diff = t.difference(i.timestamp.toDate());
          int totalMinutes = diff.inMinutes;
          int years = totalMinutes ~/ (60 * 24 * 365);
          int months = (totalMinutes % (60 * 24 * 365)) ~/ (60 * 24 * 30);
          int days= (totalMinutes % (60 * 24 * 30)) ~/ (60 * 24);
          int hours = (totalMinutes%(60*24)) ~/ 60; // Calculate total hours
          int minutes = totalMinutes % (60);

          String timeAgo = "";
          if (years > 0) timeAgo += "$years years ";
          if (months > 0) timeAgo += "$months months ";
          if (days > 0) timeAgo += "$days days ";
          if (hours > 0) timeAgo += "$hours hours "; // Include hours if non-zero
          if (minutes > 0) timeAgo += "$minutes mins ";

          sensors += getStringForVariable(i.dataType) + '\tRan ${timeAgo}ago\n';
        }
      }
    }
    isComputing.value = false;
    return sensors;
  }

  String makePumpsString(System sys)  {
    String s = 'Air Pump \n Frequency: '+ ((sys.waterPumpInterval??0) / 60).toString() +
        ' mins\t Duration: ' + ((sys.waterPumpDuration??0)/60).toString() + ' mins\nWater Pump\n Frequency: '+
        ((sys.airPumpInterval??0)/60).toString() + ' mins\t Duration: ' + ((sys.airPumpDuration??0)/60).toString() + ' mins';
    return s;
  }
}
