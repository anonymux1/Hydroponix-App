import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

enum versionName { HOME, PRO }

enum SensorType { EC, pH, temp, DO, ambientTemp, ambientHumidity }

class System {
  String systemId;
  String? Name;
  versionName? version;
  int? switches;
  int? heavySwitches;
  int? peristalticPumpsCount;
  List<SensorType>? sensors;
  Map<String, int>? modules;
  String? ssid;
  String? password;
  int? waterPumpDuration;
  int? airPumpDuration;
  int? waterPumpInterval;
  int? airPumpInterval;
  double? phMax;
  double? phMin;
  double? nutrientTempMax;
  double? nutrientTempMin;
  double? ambientTempMax;
  double? ambientTempMin;

  System({
    required this.systemId,
    this.Name,
    this.version,
    this.sensors,
    this.modules,
    this.ssid,
    this.password,
    this.waterPumpDuration,
    this.airPumpDuration,
    this.waterPumpInterval,
    this.airPumpInterval,
    this.phMax,
    this.phMin,
    this.nutrientTempMax,
    this.nutrientTempMin,
    this.ambientTempMax,
    this.ambientTempMin,
  });

  factory System.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return System(
      systemId: data?['systemId'],
      Name: data?['Name'],
      version: data?['version'],
      ssid: data?['ssid'],
      password: data?['password'],
      waterPumpDuration: data?['waterPumpDuration'],
      airPumpDuration: data?['airPumpDuration'],
      phMax: data?['phMax'],
      phMin: data?['phMin'],
      nutrientTempMax: data?['nutrientTempMax'],
      nutrientTempMin: data?['nutrientTempMin'],
      ambientTempMax: data?['ambientTempMax'],
      ambientTempMin: data?['ambientTempMin'],
      waterPumpInterval: data?['waterPumpInterval'],
      airPumpInterval: data?['airPumpInterval'],
      sensors:
          data?['sensors'] is Iterable ? List.from(data?['sensors']) : null,
      modules: data?['modules'] is Iterable ? Map.from(data?['modules']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (systemId != null) "systemId": systemId,
      if (Name != null) "Name": Name,
      if (version != null) "version": version,
      if (ssid != null) "ssid": ssid,
      if (password != null) "password": password,
      if (waterPumpDuration != null) "waterPumpDuration": waterPumpDuration,
      if (airPumpDuration != null) "airPumpDuration": airPumpDuration,
      if (phMax != null) "phMax": phMax,
      if (phMin != null) "phMin": phMin,
      if (nutrientTempMax != null) "nutrientTempMax": nutrientTempMax,
      if (nutrientTempMin != null) "nutrientTempMin": nutrientTempMin,
      if (ambientTempMax != null) "ambientTempMax": ambientTempMax,
      if (ambientTempMin != null) "ambientTempMin": ambientTempMin,
      if (waterPumpInterval != null) "waterPumpInterval": waterPumpInterval,
      if (airPumpInterval != null) "airPumpInterval": airPumpInterval,
      if (sensors != null) "sensors": sensors,
      if (modules != null) "modules": modules,
    };
  }
}
