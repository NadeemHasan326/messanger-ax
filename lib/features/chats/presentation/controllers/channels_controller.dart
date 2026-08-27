import 'package:messanger_ax/exports.dart';

class ChannelsController extends GetxController {
  final query = ''.obs;
  late final TextEditingController searchController;

  ChatsController get _chats => Get.find<ChatsController>();

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onQueryChanged(String value) => query.value = value.trim();

  List<ChatChannel> get visibleChannels {
    final all = _chats.channels.toList();
    final q = query.value.toLowerCase();
    if (q.isEmpty) return all;
    return all
        .where(
          (channel) =>
              channel.name.toLowerCase().contains(q) ||
              channel.description.toLowerCase().contains(q),
        )
        .toList();
  }

  void toggleFollow(ChatChannel channel) {
    if (channel.isAdmin) return;
    if (channel.isJoined) {
      PremiumConfirmDialog.show(
        title: 'Unfollow ${channel.name}?',
        message: 'You will stop seeing new posts from this channel in Chats.',
        confirmLabel: 'Unfollow',
        icon: Icons.campaign_outlined,
        accentColor: AppColors.error,
        onConfirm: () => _chats.unfollowChannel(channel.name),
      );
      return;
    }
    _chats.followChannel(channel.name);
  }

  void openCreate() {
    AppNavigation.push(AppRoutes.createChannel);
  }

  void openChannel(ChatChannel channel) {
    ChatNavigation.open(
      name: channel.name,
      isChannel: true,
      showCallOption: false,
    );
  }
}
