import 'dart:convert';
import 'dart:developer';

import 'package:Hydroponix/models/System.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/SystemList.dart';

class SystemsController extends GetxController  {
  final firestore = FirebaseFirestore.instance;
  String MMSSFromSec(int? sec)  {
    String Time="";
    String mins = "";
    String secs = "";
    if(sec!=null) {
      if ((sec ~/ 60)
          .toString()
          .length < 2)
        mins += "0" + (sec ~/ 60).toString();
      else
        mins += (sec ~/ 60).toString();
      if ((sec % 60)
          .toString()
          .length < 2)
        secs += "0" + (sec % 60).toString();
      else
        secs += (sec % 60).toString();
      Time = mins + ":" + secs;
      return Time;
    }
    else return "00:00";
  }

  int secFromMMSS(String time)  {
    List<String> t = time.split(":");
    int totalSec =     (t[0] as int)*60 + (t[1] as int);
    return totalSec;
  }

  Future<void> submitForm(
      SystemList userSystemList,
      System sys,
  String networkName,
  String networkPassword,
  String airPumpFreq,
  String airPumpDur,
  String waterPumpFreq,
  String waterPumpDur,
  String nutTempMin,
  String nutTempMax,
  String phMin,
  String phMax,
  String ambTempMin,
  String ambTempMax
      ) async {
    if(sys.ssid != networkName || sys.password!= networkPassword ||
        sys.phMin!= phMin || sys.phMax!= phMax ||
        sys.nutrientTempMin!=nutTempMin || sys.nutrientTempMax!=nutTempMax ||
        sys.ambientTempMin!=ambTempMin ||sys.ambientTempMax!=ambTempMax ||
        sys.airPumpDuration!=airPumpDur || sys.airPumpInterval!=airPumpFreq ||
        sys.waterPumpDuration!=waterPumpDur || sys.waterPumpInterval!=waterPumpFreq){
      int idx =0;
      for(System s in userSystemList.systemList!)  {
        if (s.systemId == sys.systemId) {
          userSystemList.systemList?[idx].ssid = networkName;
          userSystemList.systemList?[idx].password = networkPassword;
          userSystemList.systemList?[idx].nutrientTempMax = nutTempMax as int?;
          userSystemList.systemList?[idx].nutrientTempMin = nutTempMin as int?;
          userSystemList.systemList?[idx].ambientTempMax = ambTempMax as int?;
          userSystemList.systemList?[idx].ambientTempMin = ambTempMin as int?;
          userSystemList.systemList?[idx].airPumpInterval = secFromMMSS(airPumpFreq);
          userSystemList.systemList?[idx].airPumpDuration = secFromMMSS(airPumpDur);
          userSystemList.systemList?[idx].waterPumpInterval = secFromMMSS(waterPumpFreq);
          userSystemList.systemList?[idx].waterPumpDuration = secFromMMSS(waterPumpDur);
          userSystemList.systemList?[idx].phMax = phMax as double?;
          userSystemList.systemList?[idx].phMin = phMin as double?;
          //1. send message with updated system to HiveMQ
          String json = jsonEncode(s.toFirestore());
          log("Systems_controller:"+json);

          //2. update only this system in the firestore doc. Google gives conflicting info. doing 3.
        }
        idx++;
      }
      final user = FirebaseAuth.instance.currentUser;
      final docRef = firestore
          .collection('$user')
          .doc('systemList');
      docRef.update({"Systems":FieldValue.delete()});
      docRef.update({"Systems":FieldValue.arrayUnion(userSystemList.toFirestore(userSystemList.systemList!))});
      //3. If 2 is not possible, Save new userSystemList to Firestore
    }
  }
}