import 'dart:async';

import 'package:messanger_ax/exports.dart';
import 'package:messanger_ax/features/chats/data/mock_chat_messages.dart';

class ChatController extends GetxController {
  ChatController({ChatThread? thread})
      : thread = thread ?? const ChatThread(name: 'Chat');

  final ChatThread thread;
  final messages = <ChatMessage>[].obs;
  final inputController = TextEditingController();
  final inputFocusNode = FocusNode();
  final canSend = false.obs;
  final showEmojiPicker = false.obs;
  final isMuted = false.obs;
  final members = <String>[].obs;
  final pendingMemberNames = <String>[].obs;
  final admins = <String>['You'].obs;
  final onlyAdminsCanSend = false.obs;
  final selectedIds = <String>[].obs;
  final replyTo = Rxn<ChatMessage>();
  final isRecording = false.obs;
  final recordingSeconds = 0.obs;
  final voiceWillCancel = false.obs;
  int _messageSeq = 0;
  int _peerReplyIndex = 0;
  Timer? _expiryTimer;
  Timer? _deliverTimer;
  Timer? _peerTimer;
  Timer? _recordTimer;
  Offset? _recordStart;

  static const _peerReplies = ['Got it', 'Sounds good', 'Okay', '👍'];

  ProfileController? get _profile =>
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : null;

  bool get repliesEnabled => _profile?.replyAllowed.value ?? true;

  ChatWallpaper get wallpaper =>
      _profile?.chatWallpaper.value ?? ChatWallpaper.system;

  Color get wallpaperColor => ChatWallpaperStyle.color(wallpaper);

  BoxDecoration get wallpaperDecoration => ChatWallpaperStyle.decoration(
        wallpaper,
        imageBytes: _profile?.wallpaperImage.value,
      );

  bool get isSelecting => selectedIds.isNotEmpty;

  int get selectedCount => selectedIds.length;

  String get headerSubtitle {
    if (thread.isGroup) return '${members.length} members';
    return thread.online ? 'Online' : 'Offline';
  }

  List<String> get banners {
    final items = <String>[];
    if (thread.isGroup && onlyAdminsCanSend.value) {
      items.add('Only admins can send messages');
    }
    final duration = _profile?.disappearingDuration.value;
    if (duration != null && duration != DisappearingDuration.off) {
      items.add('Messages disappear after ${duration.label}');
    }
    return items;
  }

  ChatMessage reversedMessage(int index) =>
      messages[messages.length - 1 - index];

  bool isMessageSelected(String id) => selectedIds.contains(id);

  String replyAuthorOf(ChatMessage message) =>
      message.replyToMine ? 'You' : thread.name;

  String composerReplyAuthor(ChatMessage reply) =>
      reply.isMine ? 'You' : thread.name;

  String get recordingLabel {
    if (voiceWillCancel.value) return 'Release to cancel';
    return '0:${recordingSeconds.value.toString().padLeft(2, '0')}';
  }

  List<ChatOverflowItem> get overflowItems {
    final muteLabel = isMuted.value ? 'Unmute' : 'Mute';
    if (thread.isGroup) {
      return [
        const ChatOverflowItem(ChatMenuAction.viewMembers, 'View members'),
        const ChatOverflowItem(ChatMenuAction.sendPermission, 'Who can send'),
        const ChatOverflowItem(ChatMenuAction.wallpaper, 'Wallpaper'),
        ChatOverflowItem(ChatMenuAction.mute, muteLabel),
        const ChatOverflowItem(ChatMenuAction.clearChat, 'Clear chat'),
      ];
    }
    return [
      const ChatOverflowItem(ChatMenuAction.viewProfile, 'View profile'),
      const ChatOverflowItem(ChatMenuAction.wallpaper, 'Wallpaper'),
      ChatOverflowItem(ChatMenuAction.mute, muteLabel),
      const ChatOverflowItem(ChatMenuAction.clearChat, 'Clear chat'),
      const ChatOverflowItem(ChatMenuAction.block, 'Block'),
    ];
  }

  void onPopInvoked(bool didPop) {
    if (!didPop) clearSelection();
  }

  void startCall() {
    AppToast.info('Calling ${thread.name}...');
  }

  void prepareAttach() => hideEmojiPicker();

  void attachPhoto() => attachFile('photo.jpg');

  void attachViewOncePhoto() => attachFile('photo.jpg', viewOnce: true);

  void attachCameraPhoto() => attachFile('camera.jpg');

  void attachDocument() => attachFile('document.pdf');

  ChatMenuAction? onMenuAction(ChatMenuAction action) {
    switch (action) {
      case ChatMenuAction.viewProfile:
        viewProfile();
      case ChatMenuAction.mute:
        toggleMute();
      case ChatMenuAction.clearChat:
        confirmClearChat();
      case ChatMenuAction.block:
        confirmBlockUser();
      case ChatMenuAction.wallpaper:
        pickWallpaper();
      case ChatMenuAction.addMembers:
        beginAddMembers();
        return action;
      case ChatMenuAction.sendPermission:
      case ChatMenuAction.viewMembers:
        return action;
    }
    return null;
  }

  ChatMessage _createMessage({
    required String text,
    required bool isMine,
    String time = 'Now',
    String? fileName,
    ChatLocationType? locationType,
    String? liveDuration,
    bool isSystem = false,
    MessageStatus status = MessageStatus.none,
    String? replyToId,
    String? replyToText,
    bool replyToMine = false,
    Duration? voiceDuration,
    bool viewOnce = false,
  }) {
    return ChatMessage(
      id: 'msg-${++_messageSeq}',
      text: text,
      isMine: isMine,
      time: time,
      fileName: fileName,
      locationType: locationType,
      liveDuration: liveDuration,
      isSystem: isSystem,
      sentAt: DateTime.now(),
      status: status,
      replyToId: replyToId,
      replyToText: replyToText,
      replyToMine: replyToMine,
      voiceDuration: voiceDuration,
      viewOnce: viewOnce,
    );
  }

  static const _directory = [
    GroupMember(name: 'Olivia Williams', role: 'Marketing Lead', section: 'O'),
    GroupMember(name: 'Alex Rivera', role: 'Product Manager', section: 'A'),
    GroupMember(name: 'Nina Williams', role: 'Product Designer', section: 'N'),
    GroupMember(name: 'David Chen', role: 'Engineering Lead', section: 'D'),
    GroupMember(name: 'Emma Thompson', role: 'Content Strategist', section: 'E'),
    GroupMember(name: 'Liam Neeson', role: 'Sales Director', section: 'L'),
    GroupMember(name: 'Noah Parker', role: 'Data Analyst', section: 'N'),
    GroupMember(name: 'Ava Thompson', role: 'UX Designer', section: 'A'),
    GroupMember(name: 'Benjamin Lee', role: 'iOS Engineer', section: 'B'),
    GroupMember(name: 'Chloe Martinez', role: 'Marketing Lead', section: 'C'),
    GroupMember(name: 'Daniel Brooks', role: 'Backend Engineer', section: 'D'),
  ];

  @override
  void onInit() {
    super.onInit();
    messages.assignAll(
      MockChatMessages.forUser(thread.name).map(
        (message) => _createMessage(
          text: message.text,
          isMine: message.isMine,
          time: message.time,
        ),
      ),
    );
    _applyHistoricalTicks();
    if (thread.isGroup) {
      members.assignAll(const [
        'You',
        'Olivia Williams',
        'Alex Rivera',
        'Nina Williams',
        'David Chen',
      ]);
      messages.insert(
        0,
        _createMessage(
          text:
              '${members.where((name) => name != 'You').join(', ')} joined',
          isMine: false,
          isSystem: true,
        ),
      );
    }
    inputFocusNode.addListener(_onInputFocusChanged);
    DeviceEmoji.listen(insertEmoji);
    if (_profile != null) {
      ever(_profile!.disappearingDuration, (_) => _pruneExpired());
    }
    _expiryTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _pruneExpired(),
    );
    _pruneExpired();
  }

  void _applyHistoricalTicks() {
    var lastIncomingIndex = -1;
    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];
      if (!message.isMine && !message.isSystem) lastIncomingIndex = i;
    }
    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];
      if (!message.isMine || message.isSystem) continue;
      messages[i] = message.copyWith(
        status: i < lastIncomingIndex && (_profile?.readReceipts.value ?? true)
            ? MessageStatus.read
            : MessageStatus.delivered,
      );
    }
  }

  void _pruneExpired() {
    final ttl = _profile?.disappearingDuration.value.ttl;
    if (ttl == null) return;
    final cutoff = DateTime.now().subtract(ttl);
    messages.removeWhere(
      (message) =>
          !message.isSystem &&
          message.sentAt != null &&
          message.sentAt!.isBefore(cutoff),
    );
  }

  void _onInputFocusChanged() {
    if (inputFocusNode.hasFocus && showEmojiPicker.value) {
      hideEmojiPicker();
    }
  }

  void onInputChanged(String value) {
    canSend.value = value.trim().isNotEmpty;
  }

  void setReply(ChatMessage message) {
    if (!repliesEnabled || message.isSystem || message.isDeleted) return;
    hideEmojiPicker();
    replyTo.value = message;
    inputFocusNode.requestFocus();
  }

  void cancelReply() => replyTo.value = null;

  ChatMessage _outgoing({
    required String text,
    String? fileName,
    ChatLocationType? locationType,
    String? liveDuration,
    Duration? voiceDuration,
    bool viewOnce = false,
  }) {
    final reply = replyTo.value;
    return _createMessage(
      text: text,
      isMine: true,
      fileName: fileName,
      locationType: locationType,
      liveDuration: liveDuration,
      voiceDuration: voiceDuration,
      viewOnce: viewOnce,
      status: MessageStatus.sent,
      replyToId: reply?.id,
      replyToText: reply?.preview,
      replyToMine: reply?.isMine ?? false,
    );
  }

  void _commitOutgoing(ChatMessage message) {
    messages.add(message);
    replyTo.value = null;
    _scheduleDelivery(message.id);
    _schedulePeerReply();
  }

  void _scheduleDelivery(String id) {
    _deliverTimer?.cancel();
    _deliverTimer = Timer(const Duration(milliseconds: 450), () {
      _setStatus(id, MessageStatus.delivered);
    });
  }

  void _schedulePeerReply() {
    if (thread.isGroup) return;
    _peerTimer?.cancel();
    _peerTimer = Timer(const Duration(milliseconds: 1800), () {
      final text = _peerReplies[_peerReplyIndex++ % _peerReplies.length];
      messages.add(
        _createMessage(text: text, isMine: false),
      );
      _markMineRead();
    });
  }

  void _setStatus(String id, MessageStatus status) {
    final index = messages.indexWhere((message) => message.id == id);
    if (index < 0) return;
    final current = messages[index];
    if (!current.isMine || current.isDeleted) return;
    if (current.status == MessageStatus.read) return;
    messages[index] = current.copyWith(status: status);
  }

  void _markMineRead() {
    if (_profile?.readReceipts.value == false) return;
    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];
      if (!message.isMine || message.isSystem || message.isDeleted) continue;
      if (message.status == MessageStatus.read) continue;
      messages[i] = message.copyWith(status: MessageStatus.read);
    }
  }

  void sendMessage() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;
    _commitOutgoing(_outgoing(text: text));
    inputController.clear();
    canSend.value = false;
  }

  void attachFile(String fileName, {bool viewOnce = false}) {
    hideEmojiPicker();
    _commitOutgoing(
      _outgoing(
        text: viewOnce ? 'Photo' : fileName,
        fileName: fileName,
        viewOnce: viewOnce,
      ),
    );
  }

  void shareCurrentLocation() {
    hideEmojiPicker();
    _commitOutgoing(
      _outgoing(
        text: 'Current location',
        locationType: ChatLocationType.current,
      ),
    );
  }

  void shareLiveLocation(String duration) {
    hideEmojiPicker();
    _commitOutgoing(
      _outgoing(
        text: 'Live location',
        locationType: ChatLocationType.live,
        liveDuration: duration,
      ),
    );
  }

  void startVoiceRecord(LongPressStartDetails details) {
    if (canSend.value) return;
    hideEmojiPicker();
    HapticFeedback.lightImpact();
    _recordStart = details.globalPosition;
    voiceWillCancel.value = false;
    recordingSeconds.value = 0;
    isRecording.value = true;
    _recordTimer?.cancel();
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      recordingSeconds.value++;
    });
  }

  void updateVoiceDrag(LongPressMoveUpdateDetails details) {
    if (!isRecording.value || _recordStart == null) return;
    voiceWillCancel.value =
        details.globalPosition.dx < _recordStart!.dx - 72;
  }

  void endVoiceRecord(LongPressEndDetails details) {
    if (!isRecording.value) return;
    final seconds = recordingSeconds.value.clamp(1, 600);
    final cancelled = voiceWillCancel.value;
    _stopRecording();
    if (cancelled) return;
    _commitOutgoing(
      _outgoing(
        text: 'Voice message',
        voiceDuration: Duration(seconds: seconds),
      ),
    );
  }

  void cancelVoiceRecord() => _stopRecording();

  void _stopRecording() {
    _recordTimer?.cancel();
    _recordTimer = null;
    isRecording.value = false;
    voiceWillCancel.value = false;
    recordingSeconds.value = 0;
    _recordStart = null;
  }

  Future<void> openViewOnce(ChatMessage message) async {
    if (!message.isViewOnce || message.viewOnceOpened) return;
    await Get.dialog<void>(
      Dialog(
        backgroundColor: AppColors.black,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.photo_rounded,
                size: 72.sp,
                color: AppColors.white.withValues(alpha: 0.9),
              ),
              SizedBox(height: 16.h),
              Text(
                'Photo',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'This photo will disappear after you close it',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: Get.back,
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primarySoft,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final index = messages.indexWhere((item) => item.id == message.id);
    if (index < 0) return;
    messages[index] = messages[index].copyWith(viewOnceOpened: true);
  }

  void onScreenshotTaken() {
    messages.add(
      _createMessage(
        text: 'You took a screenshot',
        isMine: false,
        isSystem: true,
      ),
    );
  }

  Future<void> pickWallpaper() async {
    hideEmojiPicker();
    await _profile?.pickChatWallpaper();
  }

  Future<void> toggleEmojiPicker() async {
    if (showEmojiPicker.value) {
      await hideEmojiPicker();
      inputFocusNode.requestFocus();
      return;
    }

    inputFocusNode.unfocus();

    if (DeviceEmoji.usesInlinePicker) {
      showEmojiPicker.value = true;
      return;
    }

    final opened = await DeviceEmoji.showSystemPicker();
    if (opened) {
      showEmojiPicker.value = true;
    } else {
      inputFocusNode.requestFocus();
    }
  }

  Future<void> hideEmojiPicker() async {
    if (!showEmojiPicker.value) return;
    showEmojiPicker.value = false;
    await DeviceEmoji.hide();
  }

  void insertEmoji(String emoji) {
    final text = inputController.text;
    final selection = inputController.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final next = text.replaceRange(start, end, emoji);
    inputController.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
    canSend.value = next.trim().isNotEmpty;
  }

  void viewProfile() {
    hideEmojiPicker();
    AppNavigation.push(AppRoutes.userProfile, arguments: thread.name);
  }

  void toggleMute() {
    isMuted.toggle();
    AppToast.info(
      isMuted.value
          ? 'Muted notifications from ${thread.name}'
          : 'Unmuted ${thread.name}',
      position: AppToastPosition.top,
    );
  }

  List<GroupMember> get addableMembers => _directory
      .where((member) => !members.contains(member.name))
      .toList();

  List<GroupMember> get joinedMembers {
    return members.map((name) {
      if (name == 'You') {
        return const GroupMember(
          name: 'You',
          role: 'Group admin',
          section: 'Y',
        );
      }
      return _directory.firstWhere(
        (member) => member.name == name,
        orElse: () => GroupMember(
          name: name,
          role: 'Member',
          section: name.isEmpty ? '#' : name[0].toUpperCase(),
        ),
      );
    }).toList();
  }

  bool isGroupAdmin(String name) => admins.contains(name);

  void makeAdmin(String name) {
    if (name == 'You' || admins.contains(name)) return;
    admins.add(name);
    messages.add(
      _createMessage(
        text: 'You made $name an admin',
        isMine: false,
        isSystem: true,
      ),
    );
  }

  void dismissAdmin(String name) {
    if (name == 'You' || !admins.contains(name)) return;
    admins.remove(name);
    messages.add(
      _createMessage(
        text: 'You removed $name as admin',
        isMine: false,
        isSystem: true,
      ),
    );
  }

  void beginAddMembers() => pendingMemberNames.clear();

  void togglePendingMember(String name) {
    if (pendingMemberNames.contains(name)) {
      pendingMemberNames.remove(name);
    } else {
      pendingMemberNames.add(name);
    }
  }

  void confirmAddMembers() {
    final added = List<String>.from(pendingMemberNames);
    if (added.isEmpty) return;
    members.addAll(added);
    pendingMemberNames.clear();
    final label = added.length == 1
        ? 'You added ${added.first}'
        : 'You added ${added.join(', ')}';
    messages.add(
      _createMessage(
        text: label,
        isMine: false,
        isSystem: true,
      ),
    );
  }

  void setOnlyAdminsCanSend(bool value) => onlyAdminsCanSend.value = value;

  void onMessageLongPress(ChatMessage message) {
    if (message.isSystem || message.id.isEmpty) return;
    hideEmojiPicker();
    if (!selectedIds.contains(message.id)) {
      selectedIds.add(message.id);
    }
  }

  void onMessageTap(ChatMessage message) {
    if (selectedIds.isNotEmpty) {
      if (message.isSystem || message.id.isEmpty) return;
      if (selectedIds.contains(message.id)) {
        selectedIds.remove(message.id);
      } else {
        selectedIds.add(message.id);
      }
      return;
    }
    if (message.isViewOnce && !message.viewOnceOpened) {
      openViewOnce(message);
    }
  }

  void onMessageDragEnd(ChatMessage message, DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 280) return;
    onMessageSwipe(message);
  }

  void onMessageSwipe(ChatMessage message) {
    if (selectedIds.isNotEmpty) return;
    setReply(message);
  }

  void clearSelection() => selectedIds.clear();

  void deleteForMe() {
    messages.removeWhere((message) => selectedIds.contains(message.id));
    selectedIds.clear();
  }

  void deleteForEveryone() {
    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];
      if (!selectedIds.contains(message.id) || message.isSystem) continue;
      messages[i] = message.copyWith(
        text: 'This message was deleted',
        isDeleted: true,
        clearFile: true,
        clearLocation: true,
        clearVoice: true,
        clearReply: true,
        viewOnce: false,
        viewOnceOpened: false,
      );
    }
    selectedIds.clear();
  }

  void confirmClearChat() {
    PremiumConfirmDialog.show(
      title: 'Clear chat',
      message:
          'Delete all messages in this conversation? This cannot be undone.',
      confirmLabel: 'Clear',
      icon: Icons.delete_outline_rounded,
      accentColor: AppColors.error,
      onConfirm: clearChat,
    );
  }

  void clearChat() {
    messages.clear();
    replyTo.value = null;
  }

  void confirmBlockUser() {
    PremiumConfirmDialog.show(
      title: 'Block ${thread.name}?',
      message:
          'They will not be able to message you. You can unblock them later in Privacy.',
      confirmLabel: 'Block',
      icon: Icons.block_rounded,
      accentColor: AppColors.error,
      onConfirm: AppNavigation.back,
    );
  }

  @override
  void onClose() {
    _expiryTimer?.cancel();
    _deliverTimer?.cancel();
    _peerTimer?.cancel();
    _recordTimer?.cancel();
    DeviceEmoji.stopListening();
    inputFocusNode.removeListener(_onInputFocusChanged);
    inputFocusNode.dispose();
    inputController.dispose();
    super.onClose();
  }
}

class ChatOverflowItem {
  const ChatOverflowItem(this.action, this.label);

  final ChatMenuAction action;
  final String label;
}
