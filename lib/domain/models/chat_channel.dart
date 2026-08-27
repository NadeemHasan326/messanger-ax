class ChatChannel {
  const ChatChannel({
    required this.name,
    required this.description,
    required this.followers,
    this.lastPost = '',
    this.time = 'Now',
    this.isAdmin = false,
    this.isJoined = false,
    this.unread = 0,
    this.createdLabel = '',
  });

  final String name;
  final String description;
  final int followers;
  final String lastPost;
  final String time;
  final bool isAdmin;
  final bool isJoined;
  final int unread;
  final String createdLabel;

  static String monthLabel([DateTime? date]) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final now = date ?? DateTime.now();
    return '${months[now.month - 1]} ${now.year}';
  }

  String get displayCreated =>
      createdLabel.isEmpty ? monthLabel() : createdLabel;

  String get followersLabel {
    if (followers >= 1000) {
      final value = followers / 1000;
      final compact = value >= 10
          ? value.toStringAsFixed(0)
          : value.toStringAsFixed(1);
      return '${compact}K followers';
    }
    return '$followers followers';
  }

  ChatChannel copyWith({
    String? name,
    String? description,
    int? followers,
    String? lastPost,
    String? time,
    bool? isAdmin,
    bool? isJoined,
    int? unread,
    String? createdLabel,
  }) {
    return ChatChannel(
      name: name ?? this.name,
      description: description ?? this.description,
      followers: followers ?? this.followers,
      lastPost: lastPost ?? this.lastPost,
      time: time ?? this.time,
      isAdmin: isAdmin ?? this.isAdmin,
      isJoined: isJoined ?? this.isJoined,
      unread: unread ?? this.unread,
      createdLabel: createdLabel ?? this.createdLabel,
    );
  }
}
