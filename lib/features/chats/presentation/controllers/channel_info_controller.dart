import 'package:messanger_ax/exports.dart';
import 'package:messanger_ax/features/chats/data/mock_channel_posts.dart';

class ChannelInfoController extends GetxController {
  ChannelInfoController({required this.channelName});

  final String channelName;

  ChatController? get _chat =>
      Get.isRegistered<ChatController>() ? Get.find<ChatController>() : null;

  ChatsController? get _chats =>
      Get.isRegistered<ChatsController>() ? Get.find<ChatsController>() : null;

  ChatChannel? get channel {
    final chats = _chats;
    if (chats == null) return null;
    chats.channels.length;
    return chats.channelByName(channelName);
  }

  bool get isAdmin =>
      channel?.isAdmin ?? _chat?.thread.isChannelAdmin ?? false;

  bool get isJoined => channel?.isJoined ?? false;

  bool get isMuted => _chat?.isMuted.value ?? false;

  String get description =>
      channel?.description ?? _chat?.thread.channelDescription ?? '';

  String get followersLabel =>
      channel?.followersLabel ??
      '${_chat?.thread.followerCount ?? 0} followers';

  String get followersValue {
    final count = channel?.followers ?? _chat?.thread.followerCount ?? 0;
    if (count >= 1000) {
      final value = count / 1000;
      return value >= 10
          ? '${value.toStringAsFixed(0)}K'
          : '${value.toStringAsFixed(1)}K';
    }
    return '$count';
  }

  String get handle {
    final slug = channelName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '');
    return '@$slug';
  }

  String get inviteLink {
    final slug = handle.replaceFirst('@', '');
    return 'https://ax.app/c/$slug';
  }

  String get createdLabel =>
      channel?.displayCreated ?? ChatChannel.monthLabel();

  String get roleLabel {
    if (isAdmin) return 'Admin';
    if (isJoined) return 'Following';
    return 'Not following';
  }

  List<ChatMessage> get recentPosts {
    final posts = MockChannelPosts.forChannel(
      channelName,
      isAdmin: isAdmin,
    );
    return posts.reversed.take(3).toList();
  }

  String get postCount => '${MockChannelPosts.forChannel(
        channelName,
        isAdmin: isAdmin,
      ).length}';

  late final TextEditingController descriptionController;

  @override
  void onInit() {
    super.onInit();
    descriptionController = TextEditingController(text: description);
  }

  void follow() => _chats?.followChannel(channelName);

  void confirmUnfollow() {
    PremiumConfirmDialog.show(
      title: 'Unfollow $channelName?',
      message: 'You will stop seeing new posts from this channel in Chats.',
      confirmLabel: 'Unfollow',
      icon: Icons.campaign_outlined,
      accentColor: AppColors.error,
      onConfirm: () => _chats?.unfollowChannel(channelName),
    );
  }

  void toggleFollow() {
    if (isAdmin) return;
    if (isJoined) {
      confirmUnfollow();
      return;
    }
    follow();
  }

  void toggleMute() => _chat?.toggleMute();

  Future<void> copyInviteLink() async {
    await Clipboard.setData(ClipboardData(text: inviteLink));
    AppToast.success('Invite link copied', position: AppToastPosition.top);
  }

  void shareChannel() {
    AppToast.info(
      'Share $channelName with $inviteLink',
      position: AppToastPosition.top,
    );
  }

  Future<void> pickWallpaper() async {
    await _chat?.pickWallpaper();
  }

  void beginEditDescription() {
    descriptionController.text = description;
  }

  void saveDescription() {
    _chats?.updateChannelDescription(
      channelName,
      descriptionController.text.trim(),
    );
    AppNavigation.back();
    AppToast.success('Description updated', position: AppToastPosition.top);
  }

  void confirmDelete() {
    PremiumConfirmDialog.show(
      title: 'Delete $channelName?',
      message:
          'This removes the channel you created. Followers will stop seeing it in this app.',
      confirmLabel: 'Delete',
      icon: Icons.delete_outline_rounded,
      accentColor: AppColors.error,
      onConfirm: () {
        _chats?.deleteChannel(channelName);
        Get.until((route) => route.settings.name == AppRoutes.home);
      },
    );
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
