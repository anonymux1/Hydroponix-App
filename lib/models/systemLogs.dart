class SystemLog {
  String timestamp;
  String eventType; // 'sensor_reading', 'module_change' , etc.
  String dataType; //Sensor or Module Name
  String eventData;
  SystemLog({
    required this.timestamp,
    required this.eventType,
    required this.eventData,
    required this.dataType,
    /*ph,
    EC,
    nutrientTemp,
    ambientTemp,
    ambientHumidity,
    waterPumpRuns,
    airPumpRuns,
    nutrientPumpARuns,
    nutrientPumpBRuns,
    nutrientPumpCRuns,
    phUpPumpRuns,
    phDownPumpRuns,
    nutrientHeaterRuns,
    nutrientChillerRuns,
    humidifierRuns,
    coolerRuns,
    ACRuns,*/
});

  factory SystemLog.fromJson(Map<String, dynamic> json) {
    return SystemLog(
      timestamp: json['timestamp'],
      eventType: json['eventType'],
      dataType: json['dataType'],
      eventData: json['eventData'],
    );
  }
}