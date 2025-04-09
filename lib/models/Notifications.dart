class MyNotification {
  final int id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  bool isActed;

  MyNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.isActed = false,
  });
}