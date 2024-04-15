import 'dart:ui';

import 'SystemConfig.dart';
import 'SystemModules.dart';
import 'SystemSensors.dart';
import 'SystemVersion.dart';

class System {
  String? systemId;
  String? Name;
  SystemVersion? version;
  SystemSensors? sensors;
  SystemModules? modules;
  SystemConfig? config;

  System({
    required this.systemId,
    this.Name,
    this.version,
    this.sensors,
    this.modules,
    this.config,
  });
}
