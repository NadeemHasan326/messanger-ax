import 'package:messanger_ax/exports.dart';

class ProfileAvatarPicker extends StatelessWidget {
  const ProfileAvatarPicker({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 108.w,
        height: 108.w,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: AppColors.avatarBg.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 56.sp, color: AppColors.primary),
            ),
            Positioned(
              right: 4.w,
              bottom: 10.h,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 20.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
