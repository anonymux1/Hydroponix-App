import 'package:cloud_firestore/cloud_firestore.dart';

class SystemLog {
  Timestamp timestamp;
  String eventType; // 'sensor_reading', 'module_change' , etc.
  String dataType; //Sensor or Module Name
  int eventData;
  SystemLog({
    required this.timestamp,
    required this.eventType,
    required this.eventData,
    required this.dataType,
});

  factory SystemLog.fromJson(Map<String, dynamic> json) {
    return SystemLog(
      timestamp: json['timeStamp'],
      eventType: json['eventType'],
      dataType: json['dataType'],
      eventData: json['eventData'],
    );
  }
}