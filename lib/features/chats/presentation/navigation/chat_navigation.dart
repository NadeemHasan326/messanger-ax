import 'package:messanger_ax/exports.dart';

/// Opens the shared chat screen from profile, chat list, new chat, etc.
abstract final class ChatNavigation {
  static Future<T?>? open<T>({
    required String name,
    bool online = false,
    bool showCallOption = true,
  }) {
    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>(force: true);
    }
    return AppNavigation.push<T>(
      AppRoutes.chat,
      arguments: ChatThread(
        name: name,
        online: online,
        showCallOption: showCallOption,
      ),
    );
  }
}
