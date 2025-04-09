
class System {
  String? systemId;
  String? Name;
  String? version;
  int? switches;
  int? heavySwitches;
  double? peristalticPumpsCount;
  List<String>? sensors;
  Map<String, int>? modules;
  String? ssid;
  String? password;
  int? waterPumpDuration;
  int? airPumpDuration;
  int? waterPumpInterval;
  int? airPumpInterval;
  double? phMax;
  double? phMin;
  int? nutrientTempMax;
  int? nutrientTempMin;
  int? ambientTempMax;
  int? ambientTempMin;
  bool? use2G;
  // List<System>? systems;

  System({
    this.systemId,
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
    this.peristalticPumpsCount,
    this.switches,
    this.heavySwitches,
    this.use2G
  });

  factory System.fromFirestore(
    Map<String, dynamic> data,
  ) {
    return System(
      systemId: data['systemId'],
      Name: data['Name'],
      version: data['version'],
      ssid: data['ssid'],
      password: data['password'],
      waterPumpDuration: data['waterPumpDuration'],
      airPumpDuration: data['airPumpDuration'],
      phMax: data['phMax'],
      phMin: data['phMin'],
      peristalticPumpsCount: data['peristalticPumpsCount'],
      nutrientTempMax: data['nutrientTempMax'],
      nutrientTempMin: data['nutrientTempMin'],
      ambientTempMax: data['ambientTempMax'],
      ambientTempMin: data['ambientTempMin'],
      waterPumpInterval: data['waterPumpInterval'],
      airPumpInterval: data['airPumpInterval'],
      sensors: List.from(data['sensors']),
      modules: Map.from(data['modules']),
      switches: data['switches'],
      heavySwitches: data['heavySwitches'],
      use2G: data['use2G']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if(systemId != null) "systemId": systemId,
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
      if (peristalticPumpsCount!=null) "peristalticPumpsCount": peristalticPumpsCount,
      if (switches!=null) "switches": switches,
      if (heavySwitches!=null) "heavySwitches": heavySwitches,
      if (use2G!=null) "use2G": use2G
    };
  }
  Map<String, dynamic> toJson() => toFirestore();

}
