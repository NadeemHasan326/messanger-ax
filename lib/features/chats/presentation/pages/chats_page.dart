import 'package:messanger_ax/exports.dart';

class ChatsPage extends GetView<ChatsController> {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LandingFadeIn(
            tabIndex: 0,
            delayMs: 80,
            direction: SlideDirection.fromTopLeft,
            child: LandingHeader(
              title: 'Chats',
              subtitle: 'Stay connected, stay productive 👋',
              actionIcon: Icons.add_rounded,
              onAction: () => AppNavigation.push(AppRoutes.newChat),
            ),
          ),
          LandingFadeIn(
            tabIndex: 0,
            delayMs: 180,
            direction: SlideDirection.fromRight,
            child: SizedBox(
            height: 110.h,
            child: Obx(
            () => ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: controller.statuses.length,
              separatorBuilder: (_, _) => SizedBox(width: 14.w),
              itemBuilder: (context, index) {
                final status = controller.statuses[index];
                return GestureDetector(
                  onTap: () => controller.openUserStory(status),
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        UserAvatar(
                          name: status.name,
                          size: 68,
                          showSilhouette: status.isMine,
                          showOnline: status.online,
                          borderColor: status.isMine
                              ? null
                              : (status.ringColor ??
                                    (status.hasUpdate
                                        ? AppColors.primary
                                        : AppColors.divider)),
                          borderWidth: status.hasUpdate ? 2.8 : 2,
                        ),
                        if (status.isMine)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 22.w,
                              height: 22.w,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 2.w,
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 13.sp,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      width: 65.w,
                      child: Column(
                        children: [
                          Text(
                            status.isMine ? 'My Status' : status.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                          if (status.isMine &&
                              status.visibilityLabel != null)
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(
                                status.visibilityLabel!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.muted,
                                  height: 1.1,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                );
              },
            ),
            ),
          ),
          ),
          LandingFadeIn(
            tabIndex: 0,
            delayMs: 280,
            direction: SlideDirection.fromLeft,
            child: Obx(
              () => FilterChipBar(
                items: controller.filters,
                selectedIndex: controller.selectedFilter.value,
                onSelected: controller.selectFilter,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: LandingFadeIn(
              tabIndex: 0,
              delayMs: 380,
              direction: SlideDirection.fromBottom,
              child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softShadow,
                    blurRadius: 16.r,
                    offset: Offset(0, -4.h),
                  ),
                ],
              ),
              child: Obx(() {
                final pinned = controller.pinnedChats;
                final chats = controller.visibleChats;
                final showPinned = controller.showPinnedSection;
                return ListView(
                padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
                children: [
                  if (showPinned) ...[
                    const _SectionLabel(title: 'PINNED'),
                    ...pinned.map(
                      (chat) => _ChatTile(chat, showDivider: true),
                    ),
                    SizedBox(height: 10.h),
                    const _SectionLabel(title: 'ALL CHATS'),
                  ] else if (chats.isNotEmpty)
                    _SectionLabel(title: controller.sectionTitle),
                  if (chats.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 48.h),
                      child: Text(
                        'No chats here yet',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: AppColors.muted,
                        ),
                      ),
                    )
                  else
                    ...List.generate(chats.length, (index) {
                      final chat = chats[index];
                      final isLast = index == chats.length - 1;
                      return _ChatTile(chat, showDivider: !isLast);
                    }),
                ],
              );
              }),
            ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        color: AppColors.black.withValues(alpha: 0.8)
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile(this.chat, {this.showDivider = false});

  final ChatItem chat;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => ChatNavigation.open(
            name: chat.name,
            online: chat.online,
            isGroup: chat.isGroup,
          ),
          behavior: HitTestBehavior.opaque,
          child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              UserAvatar(
                name: chat.name,
                showOnline: chat.online,
                pinnedBadge: chat.pinned && chat.unread == 0,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        Text(
                          chat.time,
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: chat.highlightTime || chat.unread > 0
                                ? AppColors.success
                                : AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        if (chat.status != MessageStatus.none) ...[
                          Icon(
                            Icons.done_all_rounded,
                            size: 15.sp,
                            color: chat.status == MessageStatus.read
                                ? AppColors.primary
                                : AppColors.icon,
                          ),
                          SizedBox(width: 4.w),
                        ],
                        Expanded(
                          child: Text(
                            chat.message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5.sp,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                        if (chat.pinned && chat.unread == 0) ...[
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.push_pin_rounded,
                            size: 14.sp,
                            color: AppColors.icon,
                          ),
                        ],
                        if (chat.unread > 0) ...[
                          SizedBox(width: 8.w),
                          Container(
                            constraints: BoxConstraints(minWidth: 20.w),
                            height: 20.w,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${chat.unread}',
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
      ],
    );
  }
}
