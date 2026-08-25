import 'package:messanger_ax/exports.dart';

class FilterChipData {
  const FilterChipData(
    this.label, {
    this.icon,
    this.badge,
  });

  final String label;
  final IconData? icon;
  final int? badge;
}

/// Shared filter / tab chip used across chats, calls, notifications, etc.
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.data,
    required this.selected,
    this.onTap,
  });

  final FilterChipData data;
  final bool selected;
  final VoidCallback? onTap;

  static const animDuration = Duration(milliseconds: 380);
  static const animCurve = Curves.easeInOutCubic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: animDuration,
        curve: animCurve,
        height: 38.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        alignment: Alignment.center,
        // Keep a gradient in both states so BoxDecoration.lerp
        // can interpolate colors instead of flashing.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: selected
                ? const [AppColors.primarySoft, AppColors.primary]
                : [AppColors.surface, AppColors.surface],
          ),
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: AnimatedDefaultTextStyle(
          duration: animDuration,
          curve: animCurve,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.white : AppColors.navy,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (data.icon != null) ...[
                TweenAnimationBuilder<Color?>(
                  duration: animDuration,
                  curve: animCurve,
                  tween: ColorTween(
                    end: selected ? AppColors.white : AppColors.icon,
                  ),
                  builder: (context, color, _) => Icon(
                    data.icon,
                    size: 16.sp,
                    color: color,
                  ),
                ),
                SizedBox(width: 6.w),
              ],
              Text(data.label),
              if (data.badge != null && data.badge! > 0) ...[
                SizedBox(width: 6.w),
                AnimatedContainer(
                  duration: animDuration,
                  curve: animCurve,
                  constraints: BoxConstraints(minWidth: 18.w),
                  height: 18.w,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.white.withValues(alpha: 0.22)
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${data.badge}',
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
        ),
      ),
    );
  }
}
