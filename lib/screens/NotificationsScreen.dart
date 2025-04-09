import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Hydroponix/services/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: GetBuilder<NotificationController>(
          builder: (controller) {
            return ListView.builder(
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return ListTile(
                  title: Text(notification.title),
                  subtitle: Text(notification.message),
                );
              },
            );
          }
      ),
    );
  }
}
