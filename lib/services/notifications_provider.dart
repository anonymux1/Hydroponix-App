import 'package:flutter/foundation.dart';
import '../models/Notifications.dart';

class NotificationProvider extends ChangeNotifier {
  final List<MyNotification> _notifications = [];

  List<MyNotification> get notifications => _notifications;

  void addNotification(MyNotification notification) {
    _notifications.add(notification);
    notifyListeners(); // Important! Notify listeners of the change
  }

// Add more functions later to mark notifications as read/acted-upon
}
