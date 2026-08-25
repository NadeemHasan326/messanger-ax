import 'package:messanger_ax/exports.dart';

class NotificationsPage extends GetView<NotificationsController> {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LandingFadeIn(
            tabIndex: 3,
            delayMs: 80,
            direction: SlideDirection.fromTopLeft,
            child: LandingHeader(
              title: 'Notifications',
              subtitle: 'Stay updated',
              action: Obx(() {
                if (controller.unreadCount == 0) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: controller.markAllRead,
                  child: Text(
                    'Mark all read',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                );
              }),
            ),
          ),
          LandingFadeIn(
            tabIndex: 3,
            delayMs: 180,
            direction: SlideDirection.fromBottomRight,
            child: Obx(
              () => FilterChipBar(
                items: [
                  const FilterChipData('All'),
                  FilterChipData(
                    'Unread',
                    badge: controller.unreadCount > 0
                        ? controller.unreadCount
                        : null,
                  ),
                  const FilterChipData('Mentions'),
                  const FilterChipData('Groups'),
                ],
                selectedIndex: controller.selectedFilter.value,
                onSelected: controller.selectFilter,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: LandingFadeIn(
              tabIndex: 3,
              delayMs: 280,
              direction: SlideDirection.fromLeft,
              child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softShadow,
                    blurRadius: 16.r,
                    offset: Offset(0, -4.h),
                  ),
                ],
              ),
              child: Obx(() {
                final items = controller.filtered;
                final newItems =
                    items.where((e) => e.section == 'New').toList();
                final earlierItems =
                    items.where((e) => e.section == 'Earlier').toList();

                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 42.sp,
                            color: AppColors.icon,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'No notifications',
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'You’re all caught up for this filter',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
                  children: [
                    if (newItems.isNotEmpty) ...[
                      const _SectionLabel(title: 'NEW'),
                      ...List.generate(newItems.length, (index) {
                        return _NotificationTile(
                          newItems[index],
                          showDivider: index != newItems.length - 1,
                        );
                      }),
                    ],
                    if (earlierItems.isNotEmpty) ...[
                      SizedBox(height: newItems.isEmpty ? 0 : 14.h),
                      const _SectionLabel(title: 'EARLIER'),
                      ...List.generate(earlierItems.length, (index) {
                        return _NotificationTile(
                          earlierItems[index],
                          showDivider: index != earlierItems.length - 1,
                        );
                      }),
                    ],
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
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, left: 4.w),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: AppColors.muted,
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile(this.item, {this.showDivider = true});

  final NotificationItem item;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: item.unread
                ? AppColors.primary.withValues(alpha: 0.04)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(name: item.name, size: 46),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 13.5.sp,
                          color: AppColors.muted,
                          height: 1.45,
                        ),
                        children: [
                          TextSpan(
                            text: item.name,
                            style: GoogleFonts.poppins(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                          TextSpan(text: ' ${item.action}'),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.time,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5.sp,
                        color: AppColors.hint,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.unread)
                Container(
                  width: 8.w,
                  height: 8.w,
                  margin: EdgeInsets.only(top: 8.h, left: 8.w),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Divider(height: 1, color: AppColors.divider),
          ),
      ],
    );
  }
}
