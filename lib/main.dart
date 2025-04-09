import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Hydroponix/services/notifications_handler.dart';
import 'package:Hydroponix/services/notifications_controller.dart'; // Import your GetX controller
import 'app_config.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  //Set App Config
  Get.put<AppConfig>(AppConfig()); // Initialize AppConfig early
  //Setup notifications
  final notificationsHandler = NotificationsHandler(); // Initialize here
  notificationsHandler.setupNotifications();
  Get.put(NotificationController()); // Initialize NotificationController
  //RunApp
  runApp(GetMaterialApp(home: const MyApp()));
}
