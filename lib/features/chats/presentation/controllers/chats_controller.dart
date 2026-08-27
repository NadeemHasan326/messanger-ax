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
        const FilterChipData('Channels', icon: Icons.campaign_rounded),
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

  final channels = <ChatChannel>[
    const ChatChannel(
      name: 'AX Updates',
      description: 'Official news from Messanger AX',
      followers: 128,
      lastPost: 'We’ll post here when something new ships.',
      time: '10:02 AM',
      isJoined: true,
      createdLabel: 'Mar 2025',
    ),
    const ChatChannel(
      name: 'Virexon News',
      description: 'Company announcements',
      followers: 12400,
      lastPost: 'Q3 all-hands is Thursday at 4pm.',
      time: '9:10 AM',
      isJoined: true,
      unread: 2,
      createdLabel: 'Jan 2024',
    ),
    const ChatChannel(
      name: 'Design Weekly',
      description: 'Critique notes and Figma drops',
      followers: 8300,
      lastPost: 'New Figma library: buttons and chips.',
      time: 'Yesterday',
      createdLabel: 'Aug 2024',
    ),
    const ChatChannel(
      name: 'Flutter Tips',
      description: 'Short Flutter and GetX notes',
      followers: 56200,
      lastPost: 'Keep logic in controllers, keep widgets dumb.',
      time: 'Yesterday',
      createdLabel: 'May 2024',
    ),
    const ChatChannel(
      name: 'Product Hunt Daily',
      description: 'One launch worth opening',
      followers: 9100,
      lastPost: 'Today’s pick: a quieter calendar.',
      time: 'Tue',
      createdLabel: 'Nov 2024',
    ),
  ].obs;

  ChatChannel? channelByName(String name) {
    for (final channel in channels) {
      if (channel.name == name) return channel;
    }
    return null;
  }

  List<ChatItem> get joinedChannelItems {
    return channels
        .where((channel) => channel.isJoined)
        .map(
          (channel) => ChatItem(
            name: channel.name,
            message: channel.lastPost,
            time: channel.time,
            unread: channel.unread,
            isChannel: true,
            highlightTime: channel.unread > 0,
          ),
        )
        .toList();
  }

  void followChannel(String name) {
    final index = channels.indexWhere((channel) => channel.name == name);
    if (index < 0) return;
    final channel = channels[index];
    if (channel.isJoined) return;
    channels[index] = channel.copyWith(
      isJoined: true,
      followers: channel.followers + 1,
    );
    AppToast.success('Following ${channel.name}');
  }

  void unfollowChannel(String name) {
    final index = channels.indexWhere((channel) => channel.name == name);
    if (index < 0) return;
    final channel = channels[index];
    if (channel.isAdmin) {
      AppToast.info("You can't unfollow your own channel");
      return;
    }
    if (!channel.isJoined) return;
    channels[index] = channel.copyWith(
      isJoined: false,
      followers: (channel.followers - 1).clamp(0, channel.followers),
      unread: 0,
    );
    AppToast.info('Unfollowed ${channel.name}');
  }

  void updateChannelPreview(String name, String lastPost) {
    final index = channels.indexWhere((channel) => channel.name == name);
    if (index < 0) return;
    channels[index] = channels[index].copyWith(
      lastPost: lastPost,
      time: 'Now',
      unread: 0,
    );
  }

  void markChannelRead(String name) {
    final index = channels.indexWhere((channel) => channel.name == name);
    if (index < 0) return;
    if (channels[index].unread == 0) return;
    channels[index] = channels[index].copyWith(unread: 0);
  }

  bool channelNameTaken(String name) {
    final key = name.trim().toLowerCase();
    return channels.any((channel) => channel.name.toLowerCase() == key);
  }

  ChatChannel? createChannel({
    required String name,
    String description = '',
  }) {
    final trimmed = name.trim();
    if (trimmed.length < 2 || channelNameTaken(trimmed)) return null;
    final channel = ChatChannel(
      name: trimmed,
      description: description.trim(),
      followers: 1,
      lastPost: 'You created this channel',
      time: 'Now',
      isAdmin: true,
      isJoined: true,
      createdLabel: ChatChannel.monthLabel(),
    );
    channels.insert(0, channel);
    return channel;
  }

  void updateChannelDescription(String name, String description) {
    final index = channels.indexWhere((channel) => channel.name == name);
    if (index < 0) return;
    channels[index] = channels[index].copyWith(description: description.trim());
  }

  void deleteChannel(String name) {
    channels.removeWhere((channel) => channel.name == name && channel.isAdmin);
  }

  List<ChatItem> get _everyChat =>
      [...joinedChannelItems, ...pinnedChats, ...allChats];

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
      case 4:
        return 'CHANNELS';
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
      case 4:
        return _everyChat.where((chat) => chat.isChannel).toList();
      default:
        return [...joinedChannelItems, ...allChats];
    }
  }

  void selectFilter(int index) => selectedFilter.value = index;
}
