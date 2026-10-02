enum NotifType { like, comment, friend, post, birthday }

class AppNotification {
  final String name;
  final String message;
  final String time;
  final NotifType type;
  final int? targetPostIndex;
  bool isRead;

  AppNotification({
    required this.name,
    required this.message,
    required this.time,
    required this.type,
    this.targetPostIndex,
    this.isRead = false,
  });
}
