import 'package:Hydroponix/services/systeminfo_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Hydroponix/services/notifications_handler.dart';
import 'package:Hydroponix/services/notifications_controller.dart'; // Import your GetX controller
import 'app_config.dart';
import 'app.dart';
import 'firebase_options.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
//  await dotenv.load(fileName: '.env'); // Load from .env file
//  print('Does the file exist? ${await dotenv.isEveryDefined(['CLIENT_ID'])}'); // Add this line

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put<AppConfig>(AppConfig()); // Initialize AppConfig early

  final notificationsHandler = NotificationsHandler(); // Initialize here
  notificationsHandler.setupNotifications();

  Get.put(NotificationController()); // Initialize NotificationController
  Get.put(SystemInfoController());


  runApp(GetMaterialApp(home: const MyApp()));
}
