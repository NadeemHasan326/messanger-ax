class ChatThread {
  const ChatThread({
    required this.name,
    this.online = false,
    this.showCallOption = true,
  });

  final String name;
  final bool online;
  final bool showCallOption;
}
