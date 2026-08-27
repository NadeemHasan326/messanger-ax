import 'package:messanger_ax/exports.dart';

class ChatsController extends GetxController {
  final selectedFilter = 0.obs;

  List<FilterChipData> get filters => [
        const FilterChipData('All', icon: Icons.chat_bubble_rounded),
        FilterChipData(
          'Unread',
          badge: unreadChatCount > 0 ? unreadChatCount : null,
        ),
        const FilterChipData('Pinned', icon: Icons.push_pin_rounded),
        const FilterChipData('Groups', icon: Icons.people_alt_rounded),
      ];

  final statuses = <StatusItem>[
    const StatusItem(name: 'My status', isMine: true),
    const StatusItem(
      name: 'David',
      hasUpdate: true,
      online: true,
      ringColor: AppColors.primary,
    ),
    const StatusItem(
      name: 'Nina',
      hasUpdate: true,
      ringColor: AppColors.avatarCoral,
    ),
    const StatusItem(
      name: 'Alex',
      hasUpdate: true,
      online: true,
      ringColor: AppColors.avatarViolet,
    ),
    const StatusItem(
      name: 'Emma',
      hasUpdate: true,
      ringColor: AppColors.primarySoft,
    ),
  ].obs;

  final myPostedStory = Rxn<PostedStory>();

  void markMyStatusPosted(PostedStory story) {
    myPostedStory.value = story;
    statuses[0] = StatusItem(
      name: 'My status',
      isMine: true,
      hasUpdate: true,
      ringColor: AppColors.primary,
      visibilityLabel: story.visibilityLabel,
    );
  }

  bool canViewMyStatus(String viewerName) {
    final story = myPostedStory.value;
    if (story == null) return false;
    return story.viewerNames.contains(viewerName);
  }

  void openAddStory() {
    if (Get.isRegistered<AddStoryController>()) {
      Get.find<AddStoryController>().reset();
    }
    AppNavigation.push(AppRoutes.addStory);
  }

  void openUserStory(StatusItem status) {
    if (status.isMine) {
      openAddStory();
      return;
    }
    if (Get.isRegistered<StoryViewerController>()) {
      Get.delete<StoryViewerController>(force: true);
    }
    AppNavigation.push(AppRoutes.storyViewer, arguments: status.name);
  }

  void markStatusViewed(String name) {
    final index = statuses.indexWhere(
      (status) => !status.isMine && status.name == name,
    );
    if (index < 0) return;
    final current = statuses[index];
    statuses[index] = StatusItem(
      name: current.name,
      isMine: current.isMine,
      hasUpdate: false,
      online: current.online,
      ringColor: AppColors.divider,
      visibilityLabel: current.visibilityLabel,
    );
  }

  final pinnedChats = const [
    ChatItem(
      name: 'Design Team',
      message: 'New mockups are ready for review',
      time: 'Yesterday',
      pinned: true,
      unread: 3,
      isGroup: true,
      status: MessageStatus.read,
      highlightTime: true,
    ),
    ChatItem(
      name: 'Product Sync',
      message: 'Standup moved to 11:30',
      time: '10:30 AM',
      pinned: true,
      isGroup: true,
      status: MessageStatus.delivered,
    ),
  ];

  final allChats = const [
    ChatItem(
      name: 'Olivia Williams',
      message: 'Can we sync on the launch plan?',
      time: '9:41 AM',
      unread: 2,
      online: true,
      highlightTime: true,
    ),
    ChatItem(
      name: 'Liam Neeson',
      message: 'Sent you the updated deck',
      time: '8:15 AM',
      status: MessageStatus.read,
    ),
    ChatItem(
      name: 'Emma Thompson',
      message: 'Thanks! Looks great ✨',
      time: 'Sunday',
      online: true,
      status: MessageStatus.delivered,
    ),
    ChatItem(
      name: 'Noah Parker',
      message: 'Voice message',
      time: 'Sun',
      status: MessageStatus.sent,
    ),
  ];

  List<ChatItem> get _everyChat => [...pinnedChats, ...allChats];

  int get unreadChatCount =>
      _everyChat.where((chat) => chat.unread > 0).length;

  bool get showPinnedSection => selectedFilter.value == 0;

  String get sectionTitle {
    switch (selectedFilter.value) {
      case 1:
        return 'UNREAD';
      case 2:
        return 'PINNED';
      case 3:
        return 'GROUPS';
      default:
        return 'ALL CHATS';
    }
  }

  List<ChatItem> get visibleChats {
    switch (selectedFilter.value) {
      case 1:
        return _everyChat.where((chat) => chat.unread > 0).toList();
      case 2:
        return _everyChat.where((chat) => chat.pinned).toList();
      case 3:
        return _everyChat.where((chat) => chat.isGroup).toList();
      default:
        return allChats;
    }
  }

  void selectFilter(int index) => selectedFilter.value = index;
}
