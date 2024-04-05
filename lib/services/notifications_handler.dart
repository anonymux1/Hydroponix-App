import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notifications.dart';
import 'package:get/get.dart';
import 'notifications_controller.dart';

class NotificationsHandler {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> _handleBackgroundNotifications(RemoteMessage message) async {
    // Extract data
    final notification = MyNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: message.data['title'] ?? 'Default Title',
      message: message.data['message'] ?? 'No message content',
      timestamp: DateTime.now(),
    );


    // Add to GetX Controller
    Get.find<NotificationController>().addNotification(notification);
  }


  void setupNotifications() async {
    // ... request permissions and get FCM token (your existing code)

    // Foreground Notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// Extract data
      final notification = MyNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: message.data['title'] ?? 'Notification',
        message: message.data['message'] ?? '',
        timestamp: DateTime.now(),
      );
      Get.find<NotificationController>().addNotification(notification);
    });

    // Background message handling
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundNotifications);
  }
}
