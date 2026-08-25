import 'package:messanger_ax/exports.dart';

class LandingHeader extends StatelessWidget {
  const LandingHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionIcon,
    this.onAction,
    this.action,
  });

  final String title;
  final String subtitle;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  /// Custom trailing action. Takes precedence over [actionIcon].
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 14.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          if (action != null)
            action!
          else if (actionIcon != null)
            GestureDetector(
              onTap: onAction,
              child: Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primarySoft, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.buttonShadow,
                      blurRadius: 14.r,
                      offset: Offset(0, 6.h),
                    ),
                  ],
                ),
                child: Icon(actionIcon, color: AppColors.white, size: 24.sp),
              ),
            ),
        ],
      ),
    );
  }
}
