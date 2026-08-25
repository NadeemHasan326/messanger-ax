import 'package:messanger_ax/domain/models/chat_message.dart';

abstract final class MockChatMessages {
  static List<ChatMessage> forUser(String name) {
    return [
      ChatMessage(
        text: 'Hey, saw your latest update!',
        isMine: false,
        time: '9:14 AM',
      ),
      ChatMessage(
        text: 'Thanks $name — glad you liked it.',
        isMine: true,
        time: '9:16 AM',
      ),
      ChatMessage(
        text: 'Can we sync on this later today?',
        isMine: false,
        time: '9:18 AM',
      ),
      ChatMessage(
        text: 'Sure, I’m free after 4.',
        isMine: true,
        time: '9:19 AM',
      ),
    ];
  }
}
