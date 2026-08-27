class ChatThread {
  const ChatThread({
    required this.name,
    this.online = false,
    this.showCallOption = true,
    this.isGroup = false,
    this.isChannel = false,
    this.isChannelAdmin = false,
    this.followerCount = 0,
    this.channelDescription = '',
  });

  final String name;
  final bool online;
  final bool showCallOption;
  final bool isGroup;
  final bool isChannel;
  final bool isChannelAdmin;
  final int followerCount;
  final String channelDescription;
}
