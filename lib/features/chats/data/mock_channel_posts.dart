import 'package:messanger_ax/domain/models/chat_message.dart';

abstract final class MockChannelPosts {
  static List<ChatMessage> forChannel(String name, {required bool isAdmin}) {
    if (name == 'AX Updates') {
      return [
        ChatMessage(
          text: 'Welcome to AX Updates — product news from Messanger AX.',
          isMine: isAdmin,
          time: 'Mon',
        ),
        ChatMessage(
          text: 'Disappearing messages and chat wallpapers are live. Try them in Profile.',
          isMine: isAdmin,
          time: 'Yesterday',
        ),
        ChatMessage(
          text: 'Thanks for following. We’ll post here when something new ships.',
          isMine: isAdmin,
          time: '10:02 AM',
        ),
      ];
    }
    if (name == 'Virexon News') {
      return [
        ChatMessage(
          text: 'Office is closed this Friday. Have a good long weekend.',
          isMine: false,
          time: 'Mon',
        ),
        ChatMessage(
          text: 'Dark mode is rolling out this week. Update the app to get it.',
          isMine: false,
          time: 'Yesterday',
        ),
        ChatMessage(
          text: 'Q3 all-hands is Thursday at 4pm. Link is in your calendar.',
          isMine: false,
          time: '9:10 AM',
        ),
      ];
    }
    if (name == 'Design Weekly') {
      return [
        ChatMessage(
          text: 'This week’s critique is Wednesday. Bring one screen you’re stuck on.',
          isMine: false,
          time: 'Tue',
        ),
        ChatMessage(
          text: 'New Figma library: buttons, chips, and chat bubbles.',
          isMine: false,
          time: 'Yesterday',
        ),
      ];
    }
    if (name == 'Flutter Tips') {
      return [
        ChatMessage(
          text: 'Tip: wrap bottom sheets in a Wrap + isScrollControlled to avoid overflow.',
          isMine: false,
          time: 'Wed',
        ),
        ChatMessage(
          text: 'GetX: keep logic in controllers, keep widgets dumb.',
          isMine: false,
          time: 'Yesterday',
        ),
      ];
    }
    return [
      ChatMessage(
        text: isAdmin
            ? 'You created $name. Post an update whenever you’re ready.'
            : 'You’re in. New posts from $name will show up here.',
        isMine: isAdmin,
        time: 'Now',
      ),
    ];
  }
}
