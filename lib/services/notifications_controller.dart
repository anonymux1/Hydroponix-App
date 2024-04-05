import 'package:get/get.dart';
import '../models/notifications.dart';

class NotificationController extends GetxController {
  final RxList<MyNotification> _notifications = <MyNotification>[].obs; // Make list observable
  final RxInt _unreadNotificationCount = 0.obs; // Reactive unread count

  List<MyNotification> get notifications => _notifications.value; // Expose with a getter
  int get unreadNotificationCount => _unreadNotificationCount.value; // Expose count

  void addNotification(MyNotification notification) {
    _notifications.add(notification);
    if (!notification.isRead) { // Increment if the new notification is unread
      _unreadNotificationCount.value++;
    }
  }

  // Additional functions (optional, for marking as read, etc.)
  void markNotificationAsRead(int index) {
    _notifications[index].isRead = true;
    if (!_notifications[index].isRead) { // Decrement if it was originally unread
      _unreadNotificationCount.value--;
    }
    update(); // Notify GetX to rebuild dependent widgets
  }

  void markNotificationAsActed(int index) {
    _notifications[index].isActed = true;
    update();
  }
}
