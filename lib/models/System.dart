class System {
  String? systemId;
  String? Name;
  String? version;
  String? ssid;
  String? password;
  Map<String, bool>? sensors;
  int? switches;
  int? peristalticPumpsCount;
  List<String>? modules;
  Map<String, String>? moduleMappings;

  System({
    this.systemId,
    this.Name,
    this.ssid,
    this.password,
    this.version,
    this.sensors,
    this.switches,
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
          'switches': switches,
          'peristalticPumpsCount': peristalticPumpsCount,
          'modules': modules,
          'moduleMappings': moduleMappings
        };
  }
}
