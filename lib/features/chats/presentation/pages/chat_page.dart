import 'dart:io';

import 'package:messanger_ax/exports.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final thread = controller.thread;

    return Obx(() {
      ThemeController.to.isDark.value;
      final selecting = controller.isSelecting;
      return Scaffold(
      backgroundColor: controller.wallpaperColor,
      body: PopScope(
        canPop: !selecting,
        onPopInvokedWithResult: (didPop, _) => controller.onPopInvoked(didPop),
        child: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        top: false,
        child: Column(
          children: [
            Container(
              height: kToolbarHeight - 10.h,
              width: double.infinity,
              color: AppColors.surface,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 8.h),
              color: AppColors.surface,
              child: Obx(() {
                final selectedCount = controller.selectedCount;
                if (selectedCount > 0) {
                  return Row(
                    children: [
                      AppBackButton(onPressed: controller.clearSelection),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          '$selectedCount selected',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      _HeaderIconButton(
                        icon: Icons.delete_outline_rounded,
                        onTap: () => _DeleteMessagesSheet.show(context),
                      ),
                    ],
                  );
                }
                return Row(
                children: [
                  const AppBackButton(),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: thread.isGroup
                          ? () => _GroupMembersSheet.show(context)
                          : null,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          UserAvatar(
                            name: thread.name,
                            size: 40,
                            showOnline: thread.online,
                            onlineIndicatorSize: 10,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  thread.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                                if (thread.isGroup)
                                  Obx(
                                    () => Text(
                                      controller.headerSubtitle,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    controller.headerSubtitle,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.sp,
                                      color: thread.online
                                          ? AppColors.success
                                          : AppColors.muted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (thread.showCallOption) ...[
                    _HeaderIconButton(
                      icon: Icons.call_rounded,
                      onTap: controller.startCall,
                    ),
                    SizedBox(width: 8.w),
                  ],
                  const _ChatMoreButton(),
                ],
              );
              }),
            ),

            Divider(height: 1, thickness: 1, color: AppColors.divider),
            Expanded(
              child: DecoratedBox(
                decoration: controller.wallpaperDecoration,
                child: Obx(() {
                final selectedIds = controller.selectedIds.toList();
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 8.h, 0, 12.h),
                  reverse: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: controller.messages.length,
                  itemBuilder: (_, index) {
                    final message = controller.reversedMessage(index);
                    return _MessageBubble(
                      message: message,
                      selected: selectedIds.contains(message.id),
                    );
                  },
                );
              }),
              ),
            ),
            Obx(() {
              final banners = controller.banners;
              if (banners.isEmpty) return const SizedBox.shrink();
              return Column(
                children: [
                  for (final banner in banners)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      color: AppColors.chipBg,
                      child: Text(
                        banner,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                ],
              );
            }),
            const _ChatInputBar(),
            const _DeviceEmojiPanel(),
          ],
        ),
        ),
      ),
    );
    });
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, this.selected = false});

  final ChatMessage message;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    if (message.isSystem) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h, top: 2.h),
        child: Center(
          child: Text(
            message.text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.muted,
              height: 1.35,
            ),
          ),
        ),
      );
    }

    final mine = message.isMine;
    final onPrimary = mine
        ? AppColors.white.withValues(alpha: 0.85)
        : AppColors.muted;
    return GestureDetector(
      onLongPress: () => controller.onMessageLongPress(message),
      onTap: () => controller.onMessageTap(message),
      onHorizontalDragEnd: (details) =>
          controller.onMessageDragEnd(message, details),
      behavior: HitTestBehavior.opaque,
      child: ColoredBox(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.14)
            : Colors.transparent,
        child: Align(
          alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin:
                EdgeInsets.only(bottom: 8.h, left: 16.w, right: 16.w, top: 2.h),
            constraints: BoxConstraints(
              maxWidth: 0.72.sw,
              minWidth: message.isLocation ? 0.62.sw : 0,
            ),
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 8.h),
            decoration: BoxDecoration(
              color: mine ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(mine ? 16.r : 4.r),
                bottomRight: Radius.circular(mine ? 4.r : 16.r),
              ),
              border: mine ? null : Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: mine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (message.isReply)
                  _ReplyQuote(message: message, mine: mine),
                if (message.isDeleted)
                  Text(
                    'This message was deleted',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontStyle: FontStyle.italic,
                      height: 1.35,
                      color: onPrimary,
                    ),
                  )
                else if (message.isViewOnce)
                  _ViewOncePreview(message: message, mine: mine)
                else if (message.isVoice)
                  _VoicePreview(message: message, mine: mine)
                else if (message.isLocation)
                  _LocationPreview(message: message, mine: mine)
                else if (message.isAttachment)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.insert_drive_file_rounded,
                        size: 18.sp,
                        color: mine ? AppColors.white : AppColors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          message.fileName!,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5.sp,
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                            color: mine ? AppColors.white : AppColors.navy,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    message.text,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5.sp,
                      height: 1.35,
                      color: mine ? AppColors.white : AppColors.navy,
                    ),
                  ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.time,
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: mine
                            ? AppColors.white.withValues(alpha: 0.75)
                            : AppColors.muted,
                      ),
                    ),
                    if (message.showTicks) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        message.usesDoubleTick
                            ? Icons.done_all_rounded
                            : Icons.done_rounded,
                        size: 14.sp,
                        color: message.isReadTick
                            ? AppColors.white
                            : AppColors.white.withValues(alpha: 0.7),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReplyQuote extends StatelessWidget {
  const _ReplyQuote({required this.message, required this.mine});

  final ChatMessage message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
        decoration: BoxDecoration(
          color: mine
              ? AppColors.white.withValues(alpha: 0.16)
              : AppColors.chipBg,
          borderRadius: BorderRadius.circular(8.r),
          border: Border(
            left: BorderSide(
              color: mine ? AppColors.white : AppColors.primary,
              width: 2.w,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Get.find<ChatController>().replyAuthorOf(message),
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: mine ? AppColors.white : AppColors.primary,
              ),
            ),
            Text(
              message.replyToText ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                color: mine
                    ? AppColors.white.withValues(alpha: 0.8)
                    : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoicePreview extends StatelessWidget {
  const _VoicePreview({required this.message, required this.mine});

  final ChatMessage message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final barColor = mine ? AppColors.white : AppColors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.play_arrow_rounded,
          size: 22.sp,
          color: barColor,
        ),
        SizedBox(width: 6.w),
        ...message.voiceBarHeights.map(
          (height) => Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Container(
              width: 3.w,
              height: height.h,
              decoration: BoxDecoration(
                color: barColor.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          message.voiceLabel,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: mine ? AppColors.white : AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class _ViewOncePreview extends StatelessWidget {
  const _ViewOncePreview({required this.message, required this.mine});

  final ChatMessage message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final opened = message.viewOnceOpened;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          opened ? Icons.visibility_off_rounded : Icons.photo_rounded,
          size: 18.sp,
          color: mine ? AppColors.white : AppColors.primary,
        ),
        SizedBox(width: 6.w),
        Text(
          message.viewOnceLabel,
          style: GoogleFonts.poppins(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w600,
            fontStyle: opened ? FontStyle.italic : FontStyle.normal,
            color: mine ? AppColors.white : AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class _ChatInputBar extends GetView<ChatController> {
  const _ChatInputBar();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pickerOpen = controller.showEmojiPicker.value;
      final recording = controller.isRecording.value;
      final reply = controller.replyTo.value;
      return Container(
        padding: EdgeInsets.fromLTRB(
          12.w,
          10.h,
          12.w,
          pickerOpen ? 8.h : 30.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reply != null)
              _ReplyComposerBar(
                reply: reply,
                onClose: controller.cancelReply,
              ),
            Row(
              children: [
                _HeaderIconButton(
                  icon: Icons.attach_file_rounded,
                  onTap: recording
                      ? () {}
                      : () {
                          controller.prepareAttach();
                          _ChatAttachSheet.show(context);
                        },
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: recording
                      ? _RecordingStatus(
                          label: controller.recordingLabel,
                          willCancel: controller.voiceWillCancel.value,
                        )
                      : TextField(
                          controller: controller.inputController,
                          focusNode: controller.inputFocusNode,
                          onChanged: controller.onInputChanged,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => controller.sendMessage(),
                          style: GoogleFonts.poppins(
                            fontSize: 13.5.sp,
                            color: AppColors.navy,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Message...',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 13.5.sp,
                              color: AppColors.muted,
                            ),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding:
                                EdgeInsets.fromLTRB(16.w, 12.h, 8.w, 12.h),
                            suffixIcon: IconButton(
                              tooltip: pickerOpen ? 'Keyboard' : 'Emoji',
                              onPressed: controller.toggleEmojiPicker,
                              icon: Icon(
                                pickerOpen
                                    ? Icons.keyboard_rounded
                                    : Icons.emoji_emotions_outlined,
                                color: pickerOpen
                                    ? AppColors.primary
                                    : AppColors.muted,
                                size: 22.sp,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.r),
                              borderSide: BorderSide(color: AppColors.divider),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.r),
                              borderSide: BorderSide(color: AppColors.divider),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.r),
                              borderSide:
                                  const BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                ),
                SizedBox(width: 8.w),
                _SendOrMicButton(controller: controller),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _ReplyComposerBar extends StatelessWidget {
  const _ReplyComposerBar({required this.reply, required this.onClose});

  final ChatMessage reply;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.composerReplyAuthor(reply),
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  reply.preview,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5.sp,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: Icon(Icons.close_rounded, color: AppColors.icon, size: 20.sp),
          ),
        ],
      ),
    );
  }
}

class _RecordingStatus extends StatelessWidget {
  const _RecordingStatus({
    required this.label,
    required this.willCancel,
  });

  final String label;
  final bool willCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: willCancel
            ? AppColors.error.withValues(alpha: 0.1)
            : AppColors.chipBg,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: willCancel ? AppColors.error : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.mic_rounded,
            size: 18.sp,
            color: willCancel ? AppColors.error : AppColors.primary,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: willCancel ? AppColors.error : AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

class _SendOrMicButton extends StatelessWidget {
  const _SendOrMicButton({required this.controller});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final enabled = controller.canSend.value;
      final recording = controller.isRecording.value;
      return GestureDetector(
      onTap: enabled ? controller.sendMessage : null,
      onLongPressStart: enabled ? null : controller.startVoiceRecord,
      onLongPressMoveUpdate: enabled ? null : controller.updateVoiceDrag,
      onLongPressEnd: enabled ? null : controller.endVoiceRecord,
      onLongPressCancel: enabled ? null : controller.cancelVoiceRecord,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled || recording ? AppColors.primary : AppColors.surface,
          border: Border.all(
            color: enabled || recording ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Icon(
          enabled ? Icons.send_rounded : Icons.mic_rounded,
          size: 18.sp,
          color: enabled || recording ? AppColors.white : AppColors.muted,
        ),
      ),
    );
    });
  }
}

class _ChatMoreButton extends GetView<ChatController> {
  const _ChatMoreButton();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ChatMenuAction>(
      tooltip: 'More options',
      offset: Offset(0, 8.h),
      position: PopupMenuPosition.under,
      color: AppColors.surface,
      elevation: 10,
      padding: EdgeInsets.zero,
      onOpened: controller.hideEmojiPicker,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: AppColors.divider),
      ),
      onSelected: (action) {
        switch (controller.onMenuAction(action)) {
          case ChatMenuAction.addMembers:
            _AddMembersSheet.show(context);
          case ChatMenuAction.sendPermission:
            _SendPermissionSheet.show(context);
          case ChatMenuAction.viewMembers:
            _GroupMembersSheet.show(context);
          default:
            break;
        }
      },
      itemBuilder: (_) => [
        for (final item in controller.overflowItems)
          _menuItem(item.action, item.label),
      ],
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.black.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.softShadow,
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(Icons.more_vert_rounded, color: AppColors.navy, size: 20.sp),
      ),
    );
  }

  PopupMenuItem<ChatMenuAction> _menuItem(
    ChatMenuAction value,
    String label,
  ) {
    return PopupMenuItem<ChatMenuAction>(
      value: value,
      height: 40.h,
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.navy,
        ),
      ),
    );
  }
}

class _DeleteMessagesSheet extends StatelessWidget {
  const _DeleteMessagesSheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _DeleteMessagesSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 14.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'Delete message',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              _AttachTile(
                icon: Icons.delete_forever_outlined,
                label: 'Delete for everyone',
                onTap: () {
                  Navigator.pop(context);
                  controller.deleteForEveryone();
                },
              ),
              _AttachTile(
                icon: Icons.delete_outline_rounded,
                label: 'Delete for me',
                onTap: () {
                  Navigator.pop(context);
                  controller.deleteForMe();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupMembersSheet extends StatelessWidget {
  const _GroupMembersSheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _GroupMembersSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Container(
      height: 0.72.sh,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 14.h),
              UserAvatar(name: controller.thread.name, size: 64),
              SizedBox(height: 10.h),
              Text(
                controller.thread.name,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Obx(
                () => Text(
                  '${controller.members.length} members',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.muted,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  controller.beginAddMembers();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final overlay = Get.overlayContext;
                    if (overlay != null) _AddMembersSheet.show(overlay);
                  });
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                leading: CircleAvatar(
                  backgroundColor: AppColors.chipBg,
                  child: Icon(
                    Icons.person_add_alt_1_rounded,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
                title: Text(
                  'Add members',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 4.h),
                  child: Obx(
                    () => Text(
                      '${controller.members.length} members',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  final people = controller.joinedMembers;
                  final adminNames = controller.admins.toList();
                  return ListView.builder(
                    itemCount: people.length,
                    itemBuilder: (_, index) {
                      final member = people[index];
                      final isYou = member.name == 'You';
                      final isAdmin = adminNames.contains(member.name);
                      return ListTile(
                        onTap: isYou
                            ? null
                            : () => _MemberRoleSheet.show(context, member.name),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                        leading: UserAvatar(name: member.name, size: 40),
                        title: Text(
                          member.name,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.navy,
                          ),
                        ),
                        subtitle: isYou
                            ? null
                            : Text(
                                member.role,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: AppColors.muted,
                                ),
                              ),
                        trailing: isAdmin
                            ? Text(
                                'Admin',
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberRoleSheet extends StatelessWidget {
  const _MemberRoleSheet({required this.memberName});

  final String memberName;

  static Future<void> show(BuildContext context, String memberName) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MemberRoleSheet(memberName: memberName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: Obx(() {
            final isAdmin = controller.admins.toList().contains(memberName);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 14.h),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                  leading: UserAvatar(name: memberName, size: 40),
                  title: Text(
                    memberName,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  subtitle: Text(
                    isAdmin ? 'Group admin' : 'Member',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                if (!isAdmin)
                  _AttachTile(
                    icon: Icons.admin_panel_settings_outlined,
                    label: 'Make group admin',
                    onTap: () {
                      controller.makeAdmin(memberName);
                      Navigator.pop(context);
                    },
                  )
                else
                  _AttachTile(
                    icon: Icons.person_off_outlined,
                    label: 'Dismiss as admin',
                    onTap: () {
                      controller.dismissAdmin(memberName);
                      Navigator.pop(context);
                    },
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _AddMembersSheet extends StatelessWidget {
  const _AddMembersSheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _AddMembersSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Container(
      height: 0.68.sh,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 14.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'Add members',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: Obx(() {
                  final selectedNames = controller.pendingMemberNames.toList();
                  final people = controller.addableMembers;
                  if (people.isEmpty) {
                    return Center(
                      child: Text(
                        'Everyone is already in this group',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: AppColors.muted,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: people.length,
                    itemBuilder: (_, index) {
                      final member = people[index];
                      final selected = selectedNames.contains(member.name);
                      return ListTile(
                        onTap: () =>
                            controller.togglePendingMember(member.name),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                        leading: UserAvatar(name: member.name, size: 40),
                        title: Text(
                          member.name,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.navy,
                          ),
                        ),
                        subtitle: Text(
                          member.role,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: AppColors.muted,
                          ),
                        ),
                        trailing: Icon(
                          selected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: selected ? AppColors.primary : AppColors.icon,
                          size: 22.sp,
                        ),
                      );
                    },
                  );
                }),
              ),
              Obx(() {
                final count = controller.pendingMemberNames.length;
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: AuthPrimaryButton(
                    label: count == 0 ? 'Add members' : 'Add ($count)',
                    onPressed: count == 0
                        ? null
                        : () {
                            controller.confirmAddMembers();
                            Navigator.pop(context);
                          },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendPermissionSheet extends StatelessWidget {
  const _SendPermissionSheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SendPermissionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: Obx(() {
            final adminsOnly = controller.onlyAdminsCanSend.value;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 14.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      'Who can send messages',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                _PermissionTile(
                  title: 'Everyone',
                  subtitle: 'All members can send messages',
                  selected: !adminsOnly,
                  onTap: () {
                    controller.setOnlyAdminsCanSend(false);
                    Navigator.pop(context);
                  },
                ),
                _PermissionTile(
                  title: 'Only admins',
                  subtitle: 'Members can still read the chat',
                  selected: adminsOnly,
                  onTap: () {
                    controller.setOnlyAdminsCanSend(true);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.navy,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          color: AppColors.muted,
        ),
      ),
      trailing: Icon(
        selected ? Icons.check_circle_rounded : Icons.circle_outlined,
        color: selected ? AppColors.primary : AppColors.icon,
        size: 22.sp,
      ),
    );
  }
}

class _DeviceEmojiPanel extends GetView<ChatController> {
  const _DeviceEmojiPanel();

  @override
  Widget build(BuildContext context) {
    if (!DeviceEmoji.usesInlinePicker) return const SizedBox.shrink();
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Obx(() {
      if (!controller.showEmojiPicker.value) return const SizedBox.shrink();
      return ColoredBox(
        color: AppColors.surface,
        child: SizedBox(
          height: 280.h + bottomInset,
          width: double.infinity,
          child: AndroidView(
            viewType: DeviceEmoji.androidViewType,
            layoutDirection: TextDirection.ltr,
            creationParamsCodec: const StandardMessageCodec(),
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
            },
          ),
        ),
      );
    });
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.black.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.softShadow,
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.navy, size: 20.sp),
      ),
    );
  }
}

class _ChatAttachSheet extends StatelessWidget {
  const _ChatAttachSheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ChatAttachSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 16.h),
              _AttachTile(
                icon: Icons.photo_library_rounded,
                label: 'Photo',
                onTap: () {
                  Navigator.pop(context);
                  controller.attachPhoto();
                },
              ),
              _AttachTile(
                icon: Icons.visibility_rounded,
                label: 'Photo (view once)',
                subtitle: 'They can open it only once',
                onTap: () {
                  Navigator.pop(context);
                  controller.attachViewOncePhoto();
                },
              ),
              _AttachTile(
                icon: Icons.photo_camera_rounded,
                label: 'Camera',
                onTap: () {
                  Navigator.pop(context);
                  controller.attachCameraPhoto();
                },
              ),
              _AttachTile(
                icon: Icons.insert_drive_file_rounded,
                label: 'Document',
                onTap: () {
                  Navigator.pop(context);
                  controller.attachDocument();
                },
              ),
              _AttachTile(
                icon: Icons.location_on_outlined,
                label: 'Location',
                onTap: () {
                  Navigator.pop(context);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final overlay = Get.overlayContext;
                    if (overlay != null) _ChatLocationSheet.show(overlay);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachTile extends StatelessWidget {
  const _AttachTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      leading: Icon(icon, color: AppColors.navy, size: 22.sp),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.navy,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: AppColors.muted,
              ),
            ),
    );
  }
}

class _ChatLocationSheet extends StatelessWidget {
  const _ChatLocationSheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ChatLocationSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 16.h),
              _AttachTile(
                icon: Icons.my_location_rounded,
                label: 'Send current location',
                subtitle: 'Share where you are right now',
                onTap: () {
                  Navigator.pop(context);
                  controller.shareCurrentLocation();
                },
              ),
              _AttachTile(
                icon: Icons.share_location_rounded,
                label: 'Share live location',
                subtitle: 'Update in real time until you stop',
                onTap: () {
                  Navigator.pop(context);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final overlay = Get.overlayContext;
                    if (overlay != null) {
                      _ChatLiveLocationSheet.show(overlay);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatLiveLocationSheet extends StatelessWidget {
  const _ChatLiveLocationSheet();

  static const _durations = ['15 minutes', '1 hour', '8 hours'];

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ChatLiveLocationSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 14.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'Share live location',
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              for (final duration in _durations)
                _AttachTile(
                  icon: Icons.schedule_rounded,
                  label: duration,
                  onTap: () {
                    Navigator.pop(context);
                    controller.shareLiveLocation(duration);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationPreview extends StatelessWidget {
  const _LocationPreview({required this.message, required this.mine});

  final ChatMessage message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final live = message.locationType == ChatLocationType.live;
    final iconColor = mine ? AppColors.white : AppColors.primary;
    final titleColor = mine ? AppColors.white : AppColors.navy;
    final subtitleColor = mine
        ? AppColors.white.withValues(alpha: 0.75)
        : AppColors.muted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 92.h,
          decoration: BoxDecoration(
            color: mine
                ? AppColors.white.withValues(alpha: 0.16)
                : AppColors.chipBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: Icon(
            live ? Icons.share_location_rounded : Icons.location_on_rounded,
            size: 36.sp,
            color: iconColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          live ? 'Live location' : 'Current location',
          style: GoogleFonts.poppins(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        Text(
          live
              ? 'Sharing for ${message.liveDuration}'
              : 'Approximate location',
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }
}
