import 'package:messanger_ax/exports.dart';

/// Bordered back button used on secondary screens (auth, new chat, etc.).
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.size = 40,
    this.iconSize = 22,
  });

  final VoidCallback? onPressed;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? AppNavigation.back,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.black.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.softShadow,
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.arrow_back_rounded,
          color: AppColors.navy,
          size: iconSize.sp,
        ),
      ),
    );
  }
}
