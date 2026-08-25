import 'package:messanger_ax/exports.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final thread = args is ChatThread
        ? args
        : const ChatThread(name: 'Chat');
    Get.put(ChatController(thread: thread));
  }
}
