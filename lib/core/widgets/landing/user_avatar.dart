import 'package:messanger_ax/exports.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.size = 48,
    this.showOnline = false,
    this.borderColor,
    this.borderWidth = 2.5,
    this.showSilhouette = false,
    this.pinnedBadge = false,
    this.backgroundColor,
    this.onlineIndicatorSize = 15,
  });

  final String name;
  final double size;
  final bool showOnline;
  final Color? borderColor;
  final double borderWidth;
  final bool showSilhouette;
  final bool pinnedBadge;
  final Color? backgroundColor;
  final double onlineIndicatorSize;

  Color get _tone {
    return backgroundColor ??
        AppColors.avatarPalette[name.hashCode.abs() % AppColors.avatarPalette.length];
  }

  @override
  Widget build(BuildContext context) {
    final dim = size.w;
    return SizedBox(
      width: dim,
      height: dim,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: dim,
            height: dim,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: showSilhouette ? AppColors.chipBg : _tone,
              border: borderColor == null
                  ? null
                  : Border.all(color: borderColor!, width: borderWidth.w),
            ),
            alignment: Alignment.center,
            child: showSilhouette
                ? Icon(
                    Icons.person_rounded,
                    color: AppColors.icon,
                    size: (size * 0.5).sp,
                  )
                : Text(
                    name.isEmpty ? '?' : name[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: (size * 0.38).sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
          ),
          if (showOnline)
            Positioned(
              right: 3.w,
              bottom: 2.w,
              child: Container(
                width: onlineIndicatorSize.w,
                height: onlineIndicatorSize.w,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2.w),
                ),
              ),
            ),
          if (pinnedBadge)
            Positioned(
              right: -1.w,
              bottom: -1.h,
              child: Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  color: AppColors.chipBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 1.5.w),
                ),
                child: Icon(
                  Icons.push_pin_rounded,
                  size: 9.sp,
                  color: AppColors.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
