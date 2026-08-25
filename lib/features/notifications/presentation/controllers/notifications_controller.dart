import 'package:messanger_ax/exports.dart';

class NotificationsController extends GetxController {
  final selectedFilter = 0.obs;

  final items = <NotificationItem>[
    NotificationItem(
      name: 'Olivia Williams',
      action: 'reacted to your message',
      time: '2m ago',
      unread: true,
    ),
    NotificationItem(
      name: 'Design Team',
      action: 'mentioned you in a message',
      time: '15m ago',
      unread: true,
    ),
    NotificationItem(
      name: 'Liam Neeson',
      action: 'shared a file with you',
      time: '1h ago',
      unread: true,
    ),
    NotificationItem(
      name: 'Emma Thompson',
      action: 'started following you',
      time: 'Yesterday',
      section: 'Earlier',
    ),
    NotificationItem(
      name: 'Product Sync',
      action: 'added you to the group',
      time: 'Mon',
      section: 'Earlier',
    ),
  ].obs;

  void selectFilter(int index) => selectedFilter.value = index;

  void markAllRead() {
    for (final item in items) {
      item.unread = false;
    }
    items.refresh();
  }

  List<NotificationItem> get filtered {
    switch (selectedFilter.value) {
      case 1:
        return items.where((e) => e.unread).toList();
      case 2:
        return items
            .where((e) => e.action.toLowerCase().contains('mentioned'))
            .toList();
      case 3:
        return items
            .where((e) => e.action.toLowerCase().contains('group'))
            .toList();
      default:
        return items.toList();
    }
  }

  int get unreadCount => items.where((e) => e.unread).length;
}
