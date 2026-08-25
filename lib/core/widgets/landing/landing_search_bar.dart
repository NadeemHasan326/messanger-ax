import 'package:messanger_ax/exports.dart';

class LandingSearchBar extends StatelessWidget {
  const LandingSearchBar({
    super.key,
    required this.hint,
    this.onFilterTap,
    this.showFilter = true,
    this.filterLeading = false,
    this.filterLabel,
    this.controller,
    this.onChanged,
    this.autofocus = false,
    this.showMic = false,
    this.onMicTap,
    this.padding,
  });

  final String hint;
  final VoidCallback? onFilterTap;
  final bool showFilter;

  /// When true, the filter button is placed before the search field.
  final bool filterLeading;

  /// Optional label shown on the filter button instead of the tune icon.
  final String? filterLabel;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final bool showMic;
  final VoidCallback? onMicTap;
  final EdgeInsetsGeometry? padding;

  Widget _filterButton() {
    final hasLabel = filterLabel != null && filterLabel!.isNotEmpty;
    return GestureDetector(
      onTap: onFilterTap,
      child: Container(
        height: 48.h,
        constraints: BoxConstraints(minWidth: 48.w),
        padding: EdgeInsets.symmetric(horizontal: hasLabel ? 12.w : 0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.softShadow,
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: hasLabel
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filterLabel!,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.icon,
                    size: 20.sp,
                  ),
                ],
              )
            : Icon(
                Icons.tune_rounded,
                color: AppColors.icon,
                size: 22.sp,
              ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.softShadow,
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: AppColors.icon, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              autofocus: autofocus,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.navy,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.hint,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          if (showMic) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onMicTap,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.mic_none_rounded,
                color: AppColors.primary,
                size: 22.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          if (showFilter && filterLeading) ...[
            _filterButton(),
            SizedBox(width: 10.w),
          ],
          Expanded(child: _searchField()),
          if (showFilter && !filterLeading) ...[
            SizedBox(width: 10.w),
            _filterButton(),
          ],
        ],
      ),
    );
  }
}
