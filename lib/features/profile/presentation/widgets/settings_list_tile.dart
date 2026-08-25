import 'package:messanger_ax/exports.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailingText,
    this.onTap,
    this.switchValue,
    this.onSwitchChanged,
    this.destructive = false,
  });

  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final bool destructive;

  bool get _hasSwitch => onSwitchChanged != null && switchValue != null;

  @override
  Widget build(BuildContext context) {
    final titleColor = destructive ? AppColors.error : AppColors.navy;
    final iconColor = destructive ? AppColors.error : AppColors.primary;

    return GestureDetector(
      onTap: _hasSwitch
          ? () => onSwitchChanged!(!switchValue!)
          : onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: (destructive ? AppColors.error : AppColors.primary)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(leadingIcon, color: iconColor, size: 18.sp),
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5.sp,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (_hasSwitch)
              IgnorePointer(
                child: Switch.adaptive(
                  value: switchValue!,
                  onChanged: onSwitchChanged,
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.divider,
                ),
              )
            else if (trailingText != null) ...[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 120.w),
                child: Text(
                  trailingText!,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted,
                  ),
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.icon,
                  size: 22.sp,
                ),
            ] else if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.icon,
                size: 22.sp,
              ),
          ],
        ),
      ),
    );
  }
}
