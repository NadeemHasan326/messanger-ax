import 'package:messanger_ax/exports.dart';

/// Animated on / off switch for app notifications.
class NotificationToggle extends StatelessWidget {
  const NotificationToggle({super.key});

  static const _duration = Duration(milliseconds: 320);
  static const _curve = Curves.easeInOutCubic;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Obx(() {
      final enabled = controller.notificationsEnabled.value;

      return GestureDetector(
        onTap: controller.toggleNotifications,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: _duration,
          curve: _curve,
          width: 48.w,
          height: 26.h,
          padding: EdgeInsets.all(2.5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: enabled ? AppColors.primary : AppColors.divider,
          ),
          child: AnimatedAlign(
            duration: _duration,
            curve: _curve,
            alignment:
                enabled ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 21.w,
              height: 21.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 3.r,
                    offset: Offset(0, 1.h),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  enabled
                      ? Icons.notifications_rounded
                      : Icons.notifications_off_rounded,
                  key: ValueKey(enabled),
                  size: 12.sp,
                  color: enabled ? AppColors.primary : AppColors.muted,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
