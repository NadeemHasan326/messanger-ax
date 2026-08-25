class CallSession {
  const CallSession({
    required this.name,
    this.online = false,
  });

  final String name;
  final bool online;
}
