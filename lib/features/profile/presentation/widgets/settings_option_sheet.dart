import 'package:messanger_ax/exports.dart';

class SettingsOptionSheet {
  SettingsOptionSheet._();

  static Future<String?> show({
    required String title,
    required List<String> options,
    required String selected,
  }) {
    return Get.bottomSheet<String>(
      Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                ...options.map((option) {
                  final isSelected = option == selected;
                  return ListTile(
                    onTap: () => Get.back(result: option),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                    title: Text(
                      option,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                            size: 22.sp,
                          )
                        : null,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
