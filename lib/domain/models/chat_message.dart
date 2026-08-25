class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isMine,
    required this.time,
    this.fileName,
  });

  final String text;
  final bool isMine;
  final String time;
  final String? fileName;

  bool get isAttachment => fileName != null;
}
