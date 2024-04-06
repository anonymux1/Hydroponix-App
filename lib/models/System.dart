class System {
  String? systemId;
  String? Name;
  String? version;
  Map<String, bool>? sensors;
  int? switches;
  int? heavySwitches;
  int? peristalticPumpsCount;
  List<String>? modules;
  Map<String, String>? moduleMappings;
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
    this.systemId,
    this.Name,
    this.ssid,
    this.password,
    this.version,
    this.sensors,
    this.switches,
    this.heavySwitches,
    this.peristalticPumpsCount,
    this.modules,
    this.moduleMappings,
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

  toJson() {
    Map<String, dynamic> toJson() => {
          'systemId': systemId,
          'Name': Name,
          'version': version,
          'ssid': ssid,
          'password': password,
          'sensors': sensors,
          'switches': switches,
          'heavySwitches': heavySwitches,
          'peristalticPumpsCount': peristalticPumpsCount,
          'modules': modules,
          'moduleMappings': moduleMappings,
          'waterPumpDuration': waterPumpDuration,
          'airPumpDuration': airPumpDuration,
          'waterPumpInterval': waterPumpInterval,
          'airPumpInterval': airPumpInterval,
          'phMax': phMax,
          'phMin': phMin,
          'nutrientTempMax': nutrientTempMax,
          'nutrientTempMin': nutrientTempMin,
          'ambientTempMax': ambientTempMax,
          'ambientTempMin': ambientTempMin,
        };
  }
}
