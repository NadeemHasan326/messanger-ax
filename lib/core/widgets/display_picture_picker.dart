import 'package:messanger_ax/exports.dart';

class DisplayPicturePicker extends StatelessWidget {
  const DisplayPicturePicker({
    super.key,
    required this.onTap,
    this.bytes,
    this.size = 88,
    this.placeholderIcon = Icons.camera_alt_rounded,
  });

  final VoidCallback onTap;
  final Uint8List? bytes;
  final double size;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final dim = size.w;
    final hasPhoto = bytes != null && bytes!.isNotEmpty;
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: dim + 8.w,
          height: dim + 8.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: dim,
                height: dim,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.avatarBg.withValues(alpha: 0.7),
                  image: hasPhoto
                      ? DecorationImage(
                          image: MemoryImage(bytes!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: hasPhoto
                    ? null
                    : Icon(
                        placeholderIcon,
                        size: (size * 0.42).sp,
                        color: AppColors.primary,
                      ),
              ),
              Positioned(
                right: 2.w,
                bottom: 8.h,
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2.w),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 14.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
