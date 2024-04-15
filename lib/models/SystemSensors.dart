enum SensorType { EC, pH, temp, DO, ambientTemp, ambientHumidity }
class SystemSensors {
 List<SensorType> sensors;
 SystemSensors({
   required this.sensors,
});
}