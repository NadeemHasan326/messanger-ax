import 'package:messanger_ax/exports.dart';

/// Opens the shared chat screen from profile, chat list, new chat, etc.
abstract final class ChatNavigation {
  static Future<T?>? open<T>({
    required String name,
    bool online = false,
    bool showCallOption = true,
    bool isGroup = false,
    bool isChannel = false,
  }) {
    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>(force: true);
    }
    ChatChannel? channel;
    if (isChannel && Get.isRegistered<ChatsController>()) {
      final chats = Get.find<ChatsController>();
      channel = chats.channelByName(name);
      chats.markChannelRead(name);
    }
    return AppNavigation.push<T>(
      AppRoutes.chat,
      arguments: ChatThread(
        name: name,
        online: online,
        showCallOption: !isChannel && showCallOption,
        isGroup: isGroup,
        isChannel: isChannel,
        isChannelAdmin: channel?.isAdmin ?? false,
        followerCount: channel?.followers ?? 0,
        channelDescription: channel?.description ?? '',
      ),
    );
  }
}
