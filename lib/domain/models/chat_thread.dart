class ChatThread {
  const ChatThread({
    required this.name,
    this.online = false,
    this.showCallOption = true,
    this.isGroup = false,
  });

  final String name;
  final bool online;
  final bool showCallOption;
  final bool isGroup;
}
