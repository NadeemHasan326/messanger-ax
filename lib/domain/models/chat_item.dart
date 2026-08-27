import 'package:messanger_ax/core/constants/app_enums.dart';

class ChatItem {
  const ChatItem({
    required this.name,
    required this.message,
    required this.time,
    this.unread = 0,
    this.pinned = false,
    this.isGroup = false,
    this.online = false,
    this.status = MessageStatus.none,
    this.highlightTime = false,
  });

  final String name;
  final String message;
  final String time;
  final int unread;
  final bool pinned;
  final bool isGroup;
  final bool online;
  final MessageStatus status;
  final bool highlightTime;
}
