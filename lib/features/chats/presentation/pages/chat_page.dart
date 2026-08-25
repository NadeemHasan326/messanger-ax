import 'dart:io';

import 'package:messanger_ax/exports.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final thread = controller.thread;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
              child: Row(
                children: [
                  const AppBackButton(),
                  SizedBox(width: 10.w),
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
                        Text(
                          thread.online ? 'Online' : 'Offline',
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
                  if (thread.showCallOption)
                    _HeaderIconButton(
                      icon: Icons.call_rounded,
                      onTap: () => AppToast.info('Calling ${thread.name}...'),
                    ),
                ],
              ),
            ),

            Divider(height: 1, thickness: 1, color: AppColors.divider),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                  reverse: true,
                  itemCount: controller.messages.length,
                  itemBuilder: (_, index) {
                    final message = controller
                        .messages[controller.messages.length - 1 - index];
                    return _MessageBubble(message: message);
                  },
                ),
              ),
            ),
            const _ChatInputBar(),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        constraints: BoxConstraints(maxWidth: 0.72.sw),
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
            if (message.isAttachment)
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
            Text(
              message.time,
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                color: mine
                    ? AppColors.white.withValues(alpha: 0.75)
                    : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInputBar extends GetView<ChatController> {
  const _ChatInputBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 30.h),
      decoration: BoxDecoration(
        color: AppColors.surface,

        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          _HeaderIconButton(
            icon: Icons.attach_file_rounded,
            onTap: () => _ChatAttachSheet.show(context),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller.inputController,
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
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
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
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() {
            final enabled = controller.canSend.value;
            return GestureDetector(
              onTap: enabled ? controller.sendMessage : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: enabled ? AppColors.primary : AppColors.surface,
                  border: Border.all(
                    color: enabled ? AppColors.primary : AppColors.divider,
                  ),
                ),
                child: Icon(
                  Icons.send_rounded,
                  size: 18.sp,
                  color: enabled ? AppColors.white : AppColors.muted,
                ),
              ),
            );
          }),
        ],
      ),
    );
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
                  controller.attachFile('photo.jpg');
                },
              ),
              _AttachTile(
                icon: Icons.photo_camera_rounded,
                label: 'Camera',
                onTap: () {
                  Navigator.pop(context);
                  controller.attachFile('camera.jpg');
                },
              ),
              _AttachTile(
                icon: Icons.insert_drive_file_rounded,
                label: 'Document',
                onTap: () {
                  Navigator.pop(context);
                  controller.attachFile('document.pdf');
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
  });

  final IconData icon;
  final String label;
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
    );
  }
}
