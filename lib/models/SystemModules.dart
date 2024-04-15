enum ModuleType {
  airPump, waterPump, nutrientHeater, nutrientChiller, desertAirCooler,
  humidifier, AC, ledLights, uvSterilizer
}

class SystemModules {
  Map<ModuleType, int>? modules;
  SystemModules({
    required this.modules,
});
}