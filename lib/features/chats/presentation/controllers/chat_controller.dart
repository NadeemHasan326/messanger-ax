import 'package:messanger_ax/exports.dart';
import 'package:messanger_ax/features/chats/data/mock_chat_messages.dart';

class ChatController extends GetxController {
  ChatController({ChatThread? thread})
      : thread = thread ?? const ChatThread(name: 'Chat');

  final ChatThread thread;
  final messages = <ChatMessage>[].obs;
  final inputController = TextEditingController();
  final canSend = false.obs;

  @override
  void onInit() {
    super.onInit();
    messages.assignAll(MockChatMessages.forUser(thread.name));
  }

  void onInputChanged(String value) {
    canSend.value = value.trim().isNotEmpty;
  }

  void sendMessage() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;
    messages.add(
      ChatMessage(text: text, isMine: true, time: 'Now'),
    );
    inputController.clear();
    canSend.value = false;
  }

  void attachFile(String fileName) {
    messages.add(
      ChatMessage(
        text: fileName,
        isMine: true,
        time: 'Now',
        fileName: fileName,
      ),
    );
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}
