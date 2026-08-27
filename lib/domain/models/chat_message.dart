import 'package:messanger_ax/core/constants/app_enums.dart';

class ChatMessage {
  const ChatMessage({
    this.id = '',
    required this.text,
    required this.isMine,
    required this.time,
    this.fileName,
    this.locationType,
    this.liveDuration,
    this.isSystem = false,
    this.isDeleted = false,
    this.sentAt,
    this.status = MessageStatus.none,
    this.replyToId,
    this.replyToText,
    this.replyToMine = false,
    this.voiceDuration,
    this.viewOnce = false,
    this.viewOnceOpened = false,
  });

  final String id;
  final String text;
  final bool isMine;
  final String time;
  final String? fileName;
  final ChatLocationType? locationType;
  final String? liveDuration;
  final bool isSystem;
  final bool isDeleted;
  final DateTime? sentAt;
  final MessageStatus status;
  final String? replyToId;
  final String? replyToText;
  final bool replyToMine;
  final Duration? voiceDuration;
  final bool viewOnce;
  final bool viewOnceOpened;

  bool get isAttachment =>
      fileName != null && !isDeleted && !viewOnce && voiceDuration == null;
  bool get isLocation => locationType != null && !isDeleted;
  bool get isVoice => voiceDuration != null && !isDeleted;
  bool get isViewOnce => viewOnce && !isDeleted;
  bool get isReply => replyToText != null && replyToText!.isNotEmpty;
  bool get showTicks =>
      isMine && !isDeleted && status != MessageStatus.none;
  bool get usesDoubleTick =>
      status == MessageStatus.delivered || status == MessageStatus.read;
  bool get isReadTick => status == MessageStatus.read;
  String get viewOnceLabel =>
      viewOnceOpened ? 'Opened' : 'Photo · View once';

  List<double> get voiceBarHeights {
    final seed = id.hashCode.abs();
    return List.generate(12, (index) => 6.0 + ((seed + index * 17) % 16));
  }

  String get preview {
    if (isDeleted) return 'This message was deleted';
    if (isVoice) return 'Voice message';
    if (isViewOnce) return viewOnceOpened ? 'Opened' : 'Photo';
    if (isLocation) return text;
    if (fileName != null) return fileName!;
    return text;
  }

  String get voiceLabel {
    final duration = voiceDuration;
    if (duration == null) return '';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isMine,
    String? time,
    String? fileName,
    ChatLocationType? locationType,
    String? liveDuration,
    bool? isSystem,
    bool? isDeleted,
    DateTime? sentAt,
    MessageStatus? status,
    String? replyToId,
    String? replyToText,
    bool? replyToMine,
    Duration? voiceDuration,
    bool? viewOnce,
    bool? viewOnceOpened,
    bool clearFile = false,
    bool clearLocation = false,
    bool clearVoice = false,
    bool clearReply = false,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isMine: isMine ?? this.isMine,
      time: time ?? this.time,
      fileName: clearFile ? null : fileName ?? this.fileName,
      locationType: clearLocation ? null : locationType ?? this.locationType,
      liveDuration: clearLocation ? null : liveDuration ?? this.liveDuration,
      isSystem: isSystem ?? this.isSystem,
      isDeleted: isDeleted ?? this.isDeleted,
      sentAt: sentAt ?? this.sentAt,
      status: status ?? this.status,
      replyToId: clearReply ? null : replyToId ?? this.replyToId,
      replyToText: clearReply ? null : replyToText ?? this.replyToText,
      replyToMine: clearReply ? false : replyToMine ?? this.replyToMine,
      voiceDuration: clearVoice ? null : voiceDuration ?? this.voiceDuration,
      viewOnce: viewOnce ?? this.viewOnce,
      viewOnceOpened: viewOnceOpened ?? this.viewOnceOpened,
    );
  }
}
