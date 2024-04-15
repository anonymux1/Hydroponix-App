class SystemConfig {
  String ssid;
  String password;
  int waterPumpDuration;
  int airPumpDuration;
  int waterPumpInterval;
  int airPumpInterval;
  double phMax;
  double phMin;
  double nutrientTempMax;
  double nutrientTempMin;
  double ambientTempMax;
  double ambientTempMin;
  SystemConfig({
    required this.ssid,
    required this.password,
    required this.waterPumpDuration,
    required this.airPumpDuration,
    required this.waterPumpInterval,
    required this.airPumpInterval,
    required this.phMax,
    required this.phMin,
    required this.nutrientTempMax,
    required this.nutrientTempMin,
    required this.ambientTempMax,
    required this.ambientTempMin,
});
}