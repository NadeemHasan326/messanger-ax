import 'package:messanger_ax/exports.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          LandingFadeIn(
            tabIndex: 4,
            delayMs: 80,
            direction: SlideDirection.fromTopRight,
            child: ColoredBox(
              color: AppColors.background,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: controller.openAccount,
                      child: Stack(
                        children: [
                          Obx(
                            () => UserAvatar(
                              name: controller.name.value,
                              size: 72,
                              showOnline: true,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 24.w,
                              height: 24.w,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.background,
                                  width: 2.w,
                                ),
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                size: 12.sp,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              controller.name.value,
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: const BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  controller.status.value,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.navy,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.icon,
                                  size: 18.sp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: LandingFadeIn(
              tabIndex: 4,
              delayMs: 220,
              direction: SlideDirection.fromBottom,
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                children: [
                  Obx(
                    () => Column(
                      children: [
                        for (final item in controller.menu)
                          _MenuTile(
                            item: item,
                            onTap: () => controller.openMenu(item),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: controller.logout,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: AppColors.primary,
                            size: 22.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Log Out',
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: controller.deleteAccount,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.error,
                            size: 22.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Delete Account',
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 22.h),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          AppConstants.appName,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy.withValues(alpha: 0.55),
                            letterSpacing: 0.2,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'v${ProfileController.appVersion}',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item, required this.onTap});

  final ProfileMenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.logoBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5.sp,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          if (item.showThemeToggle)
            const ThemeToggle()
          else if (item.showNotificationToggle)
            const NotificationToggle()
          else
            Icon(Icons.chevron_right_rounded, color: AppColors.icon),
        ],
      ),
    );

    if (item.showThemeToggle || item.showNotificationToggle) return tile;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: tile,
    );
  }
}
