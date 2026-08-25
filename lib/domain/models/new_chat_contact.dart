class NewChatContact {
  const NewChatContact({
    required this.name,
    required this.role,
    required this.section,
    this.online = false,
    this.recent = false,
  });

  final String name;
  final String role;
  final String section;
  final bool online;
  final bool recent;
}
