class NotificationAlert {
  String id;
  String type; // Emergency, Warning, Info
  String title;
  String message;
  DateTime dateTime;
  String status; // Active, Inactive
  int sentTo;

  NotificationAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.dateTime,
    required this.status,
    required this.sentTo,
  });
}
