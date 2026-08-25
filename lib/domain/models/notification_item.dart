class NotificationItem {
  NotificationItem({
    required this.name,
    required this.action,
    required this.time,
    this.unread = false,
    this.section = 'New',
  });

  final String name;
  final String action;
  final String time;
  bool unread;
  final String section;
}
