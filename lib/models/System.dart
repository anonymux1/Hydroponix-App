class System {
  String? systemId;
  String? Name;
  String? version;
  String? ssid;
  String? password;
  Map<String, bool>? sensors;
  int? lightDutySwitches = 0;
  int? heavyDutySwitches = 0;
  int? peristalticPumpsCount = 0;
  List<String>? modules;
  Map<String, String>? moduleMappings;

  System({
    this.systemId,
    this.Name,
    this.ssid,
    this.password,
    this.version,
    this.sensors,
    this.lightDutySwitches,
    this.heavyDutySwitches,
    this.peristalticPumpsCount,
    this.modules,
    this.moduleMappings,
  });

  toJson() {
    Map<String, dynamic> toJson() => {
          'systemId': systemId,
          'Name': Name,
          'version': version,
          'ssid': ssid,
          'password': password,
          'sensors': sensors,
          'lightDutySwitches': lightDutySwitches,
          'heavyDutySwitches': heavyDutySwitches,
          'peristalticPumpsCount': peristalticPumpsCount,
          'modules': modules,
          'moduleMappings': moduleMappings
        };
  }
}
