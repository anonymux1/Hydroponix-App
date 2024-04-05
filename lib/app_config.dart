// app_config.dart
//import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();
  final String clientId = 'your_actual_client_id';

  //final String clientId = dotenv.env['CLIENT_ID']!;
}
