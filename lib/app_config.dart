// app_config.dart
//import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();
  final String clientId = '643683883154-3fsu51dq3fsrrn91366gqtm5bt1a0had.apps.googleusercontent.com';

//final String clientId = dotenv.env['CLIENT_ID']!;
}
