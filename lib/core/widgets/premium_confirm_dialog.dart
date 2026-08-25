import 'package:messanger_ax/exports.dart';

class PremiumConfirmDialog extends StatelessWidget {
  const PremiumConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.icon,
    required this.accentColor,
    required this.onConfirm,
    this.cancelLabel = 'Cancel',
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onConfirm;

  static Future<void> show({
    required String title,
    required String message,
    required String confirmLabel,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onConfirm,
    String cancelLabel = 'Cancel',
  }) {
    return Get.generalDialog(
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.32),
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (context, animation, secondaryAnimation) {
        return PremiumConfirmDialog(
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          icon: icon,
          accentColor: accentColor,
          onConfirm: onConfirm,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.88, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      elevation: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 32.r,
              offset: Offset(0, 16.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accentColor.withValues(alpha: 0.22),
                    accentColor.withValues(alpha: 0.08),
                  ],
                ),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(icon, color: accentColor, size: 28.sp),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: AppColors.muted,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    label: cancelLabel,
                    onTap: Get.back,
                    foreground: AppColors.navy,
                    background: AppColors.chipBg,
                    borderColor: AppColors.divider,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _DialogButton(
                    label: confirmLabel,
                    onTap: () {
                      Get.back();
                      onConfirm();
                    },
                    foreground: AppColors.white,
                    background: accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.onTap,
    required this.foreground,
    required this.background,
    this.borderColor,
  });

  final String label;
  final VoidCallback onTap;
  final Color foreground;
  final Color background;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14.r),
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: foreground,
          ),
        ),
      ),
    );
  }
}
