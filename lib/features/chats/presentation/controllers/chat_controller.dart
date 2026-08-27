import 'dart:async';

import 'package:messanger_ax/exports.dart';
import 'package:messanger_ax/features/chats/data/mock_channel_posts.dart';
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
  final isChatLocked = false.obs;
  final isSearching = false.obs;
  final searchQuery = ''.obs;
  final searchController = TextEditingController();
  final isContactSaved = false.obs;
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

  ChatsController? get _chats =>
      Get.isRegistered<ChatsController>() ? Get.find<ChatsController>() : null;

  ChatChannel? get channel {
    final chats = _chats;
    if (chats == null) return null;
    chats.channels.length;
    return chats.channelByName(thread.name);
  }

  bool get isJoinedChannel => channel?.isJoined ?? false;

  bool get showComposer {
    if (thread.isChannel) return thread.isChannelAdmin;
    return true;
  }

  String get composerHint =>
      thread.isChannel ? 'Post an update...' : 'Message...';

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
    if (thread.isChannel) {
      return channel?.followersLabel ??
          '${thread.followerCount} followers';
    }
    if (thread.isGroup) return '${members.length} members';
    return thread.online ? 'Online' : 'Offline';
  }

  List<String> get banners {
    final joined = isJoinedChannel;
    final onlyAdmins = onlyAdminsCanSend.value;
    final duration = _profile?.disappearingDuration.value;
    final items = <String>[];
    if (thread.isChannel && !thread.isChannelAdmin) {
      items.add(
        joined
            ? 'Only channel admins can post'
            : 'Follow to see new posts in Chats',
      );
    }
    if (thread.isGroup && onlyAdmins) {
      items.add('Only admins can send messages');
    }
    if (!thread.isChannel &&
        duration != null &&
        duration != DisappearingDuration.off) {
      items.add('Messages disappear after ${duration.label}');
    }
    return items;
  }

  ChatMessage reversedMessage(int index) =>
      visibleMessages[visibleMessages.length - 1 - index];

  List<ChatMessage> get visibleMessages {
    final q = searchQuery.value.trim().toLowerCase();
    final all = messages.toList();
    if (!isSearching.value || q.isEmpty) return all;
    return all
        .where(
          (message) =>
              !message.isDeleted && message.text.toLowerCase().contains(q),
        )
        .toList();
  }

  List<ChatMessage> get mediaMessages => messages
      .where(
        (message) =>
            message.isAttachment ||
            message.text.toLowerCase().contains('http'),
      )
      .toList();

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
    final muteLabel =
        isMuted.value ? 'Unmute notifications' : 'Mute notifications';
    if (thread.isChannel) {
      return [
        const ChatOverflowItem(
          ChatMenuAction.channelInfo,
          'View info',
          Icons.campaign_outlined,
        ),
        const ChatOverflowItem(
          ChatMenuAction.search,
          'Search',
          Icons.search_rounded,
        ),
        const ChatOverflowItem(
          ChatMenuAction.mediaLinksDocs,
          'Media, links, and docs',
          Icons.photo_library_outlined,
        ),
        ChatOverflowItem(ChatMenuAction.mute, muteLabel, Icons.notifications_off_outlined),
        const ChatOverflowItem(
          ChatMenuAction.wallpaper,
          'Chat theme',
          Icons.palette_outlined,
        ),
        const ChatOverflowItem(ChatMenuAction.more, 'More', Icons.more_horiz_rounded),
      ];
    }
    if (thread.isGroup) {
      return [
        const ChatOverflowItem(
          ChatMenuAction.viewMembers,
          'Group info',
          Icons.groups_outlined,
        ),
        const ChatOverflowItem(
          ChatMenuAction.search,
          'Search',
          Icons.search_rounded,
        ),
        const ChatOverflowItem(
          ChatMenuAction.mediaLinksDocs,
          'Media, links, and docs',
          Icons.photo_library_outlined,
        ),
        ChatOverflowItem(ChatMenuAction.mute, muteLabel, Icons.notifications_off_outlined),
        const ChatOverflowItem(
          ChatMenuAction.disappearing,
          'Disappearing messages',
          Icons.timer_outlined,
        ),
        const ChatOverflowItem(
          ChatMenuAction.wallpaper,
          'Chat theme',
          Icons.palette_outlined,
        ),
        const ChatOverflowItem(ChatMenuAction.more, 'More', Icons.more_horiz_rounded),
      ];
    }
    return [
      if (!isContactSaved.value)
        const ChatOverflowItem(
          ChatMenuAction.addToContacts,
          'Add to contacts',
          Icons.person_add_alt_1_outlined,
        ),
      const ChatOverflowItem(
        ChatMenuAction.search,
        'Search',
        Icons.search_rounded,
      ),
      const ChatOverflowItem(
        ChatMenuAction.mediaLinksDocs,
        'Media, links, and docs',
        Icons.photo_library_outlined,
      ),
      ChatOverflowItem(
        ChatMenuAction.chatLock,
        isChatLocked.value ? 'Unlock chat' : 'Chat Lock',
        Icons.lock_outline_rounded,
      ),
      const ChatOverflowItem(
        ChatMenuAction.hideChat,
        'Hide Chat 🔒',
        Icons.visibility_off_outlined,
      ),
      ChatOverflowItem(ChatMenuAction.mute, muteLabel, Icons.notifications_off_outlined),
      const ChatOverflowItem(
        ChatMenuAction.disappearing,
        'Disappearing messages',
        Icons.timer_outlined,
      ),
      const ChatOverflowItem(
        ChatMenuAction.wallpaper,
        'Chat theme',
        Icons.palette_outlined,
      ),
      const ChatOverflowItem(ChatMenuAction.more, 'More', Icons.more_horiz_rounded),
    ];
  }

  List<ChatOverflowItem> get moreItems {
    if (thread.isChannel) {
      return [
        const ChatOverflowItem(
          ChatMenuAction.report,
          'Report',
          Icons.error_outline_rounded,
        ),
        if (isJoinedChannel && !thread.isChannelAdmin)
          const ChatOverflowItem(
            ChatMenuAction.unfollow,
            'Unfollow',
            Icons.person_remove_alt_1_outlined,
          ),
        const ChatOverflowItem(
          ChatMenuAction.clearChat,
          'Clear chat',
          Icons.delete_outline_rounded,
        ),
      ];
    }
    if (thread.isGroup) {
      return [
        const ChatOverflowItem(
          ChatMenuAction.report,
          'Report',
          Icons.error_outline_rounded,
        ),
        const ChatOverflowItem(
          ChatMenuAction.clearChat,
          'Clear chat',
          Icons.delete_outline_rounded,
        ),
        const ChatOverflowItem(
          ChatMenuAction.exportChat,
          'Export chat',
          Icons.swap_vert_rounded,
        ),
        const ChatOverflowItem(
          ChatMenuAction.addShortcut,
          'Add shortcut',
          Icons.reply_rounded,
        ),
        const ChatOverflowItem(
          ChatMenuAction.sendPermission,
          'Who can send',
          Icons.admin_panel_settings_outlined,
        ),
        const ChatOverflowItem(
          ChatMenuAction.addMembers,
          'Add members',
          Icons.person_add_alt_1_outlined,
        ),
      ];
    }
    return const [
      ChatOverflowItem(
        ChatMenuAction.report,
        'Report',
        Icons.error_outline_rounded,
      ),
      ChatOverflowItem(
        ChatMenuAction.block,
        'Block',
        Icons.block_rounded,
      ),
      ChatOverflowItem(
        ChatMenuAction.clearChat,
        'Clear chat',
        Icons.delete_outline_rounded,
      ),
      ChatOverflowItem(
        ChatMenuAction.exportChat,
        'Export chat',
        Icons.swap_vert_rounded,
      ),
      ChatOverflowItem(
        ChatMenuAction.addShortcut,
        'Add shortcut',
        Icons.shortcut,
      ),
      ChatOverflowItem(
        ChatMenuAction.addToList,
        'Add to list',
        Icons.account_balance_wallet_outlined,
      ),
    ];
  }

  void onPopInvoked(bool didPop) {
    if (didPop) return;
    if (isSearching.value) {
      endSearch();
      return;
    }
    clearSelection();
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
      case ChatMenuAction.mediaLinksDocs:
      case ChatMenuAction.more:
      case ChatMenuAction.addToList:
        return action;
      case ChatMenuAction.channelInfo:
        openChannelInfo();
      case ChatMenuAction.unfollow:
        confirmUnfollow();
      case ChatMenuAction.addToContacts:
        addToContacts();
      case ChatMenuAction.search:
        beginSearch();
      case ChatMenuAction.chatLock:
        toggleChatLock();
      case ChatMenuAction.hideChat:
        confirmHideChat();
      case ChatMenuAction.disappearing:
        pickDisappearingMessages();
      case ChatMenuAction.report:
        confirmReport();
      case ChatMenuAction.exportChat:
        exportChat();
      case ChatMenuAction.addShortcut:
        addShortcut();
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
    if (thread.isChannel) {
      messages.assignAll(
        MockChannelPosts.forChannel(
          thread.name,
          isAdmin: thread.isChannelAdmin,
        ).map(
          (message) => _createMessage(
            text: message.text,
            isMine: message.isMine,
            time: message.time,
          ),
        ),
      );
    } else {
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
    }
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
    if (thread.isChannel) return;
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
      status: thread.isChannel ? MessageStatus.none : MessageStatus.sent,
      replyToId: reply?.id,
      replyToText: reply?.preview,
      replyToMine: reply?.isMine ?? false,
    );
  }

  void _commitOutgoing(ChatMessage message) {
    messages.add(message);
    replyTo.value = null;
    if (thread.isChannel) {
      _chats?.updateChannelPreview(thread.name, message.preview);
      return;
    }
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
    if (thread.isGroup || thread.isChannel) return;
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
    if (thread.isChannel && !thread.isChannelAdmin) return;
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
    if (thread.isChannel || canSend.value) return;
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

  void openChannelInfo() {
    hideEmojiPicker();
    if (Get.isRegistered<ChannelInfoController>()) {
      Get.delete<ChannelInfoController>(force: true);
    }
    AppNavigation.push(AppRoutes.channelInfo, arguments: thread.name);
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

  void beginSearch() {
    hideEmojiPicker();
    isSearching.value = true;
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void endSearch() {
    isSearching.value = false;
    searchQuery.value = '';
    searchController.clear();
  }

  void addToContacts() {
    isContactSaved.value = true;
    AppToast.success(
      '${thread.name} added to contacts',
      position: AppToastPosition.top,
    );
  }

  void toggleChatLock() {
    isChatLocked.toggle();
    AppToast.info(
      isChatLocked.value
          ? 'Chat lock is on for ${thread.name}'
          : 'Chat lock is off',
      position: AppToastPosition.top,
    );
  }

  void confirmHideChat() {
    PremiumConfirmDialog.show(
      title: 'Hide chat with ${thread.name}?',
      message:
          'This chat will be hidden from Chats. You can find it again from the hidden chats lock.',
      confirmLabel: 'Hide',
      icon: Icons.visibility_off_outlined,
      accentColor: AppColors.navy,
      onConfirm: () {
        AppToast.info('Chat hidden', position: AppToastPosition.top);
        AppNavigation.back();
      },
    );
  }

  Future<void> pickDisappearingMessages() async {
    hideEmojiPicker();
    await _profile?.pickDisappearingDuration();
  }

  void confirmReport() {
    PremiumConfirmDialog.show(
      title: 'Report ${thread.name}?',
      message:
          'The last few messages in this chat will be forwarded to Messanger AX. This person won’t be notified.',
      confirmLabel: 'Report',
      icon: Icons.error_outline_rounded,
      accentColor: AppColors.error,
      onConfirm: () => AppToast.success(
        'Reported ${thread.name}',
        position: AppToastPosition.top,
      ),
    );
  }

  void exportChat() {
    AppToast.success(
      'Chat with ${thread.name} exported',
      position: AppToastPosition.top,
    );
  }

  void addShortcut() {
    AppToast.success(
      'Shortcut added for ${thread.name}',
      position: AppToastPosition.top,
    );
  }

  void addToChatList(String listName) {
    AppToast.success(
      '${thread.name} added to $listName',
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

  void followChannel() {
    _chats?.followChannel(thread.name);
  }

  void confirmUnfollow() {
    PremiumConfirmDialog.show(
      title: 'Unfollow ${thread.name}?',
      message: 'You will stop seeing new posts from this channel in Chats.',
      confirmLabel: 'Unfollow',
      icon: Icons.campaign_outlined,
      accentColor: AppColors.error,
      onConfirm: () => _chats?.unfollowChannel(thread.name),
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
    searchController.dispose();
    super.onClose();
  }
}

class ChatOverflowItem {
  const ChatOverflowItem(this.action, this.label, this.icon);

  final ChatMenuAction action;
  final String label;
  final IconData icon;
}
