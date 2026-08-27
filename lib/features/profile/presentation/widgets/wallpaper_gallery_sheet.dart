import 'package:messanger_ax/exports.dart';
import 'package:photo_manager/photo_manager.dart';

class WallpaperGallerySheet {
  WallpaperGallerySheet._();

  static Future<void> show() {
    return Get.bottomSheet<void>(
      const _WallpaperGallerySheet(),
      isScrollControlled: true,
    );
  }
}

class _WallpaperGallerySheet extends GetView<ProfileController> {
  const _WallpaperGallerySheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.58.sh,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: Column(
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
                  'Choose from gallery',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: Obx(() {
                  if (controller.wallpaperGalleryLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final error = controller.wallpaperGalleryError.value;
                  if (error != null) {
                    return _GalleryState(
                      message: error,
                      onRetry: controller.loadWallpaperGallery,
                    );
                  }
                  if (controller.wallpaperAssets.isEmpty) {
                    return _GalleryState(
                      message: 'No photos found on this device.',
                      onRetry: controller.loadWallpaperGallery,
                    );
                  }
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                    ),
                    itemCount: controller.wallpaperAssets.length,
                    itemBuilder: (_, index) {
                      final asset = controller.wallpaperAssets[index];
                      return _WallpaperAssetTile(
                        asset: asset,
                        onTap: () => controller.applyWallpaperAsset(asset),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryState extends StatelessWidget {
  const _GalleryState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 36.sp,
              color: AppColors.muted,
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: AppColors.muted,
              ),
            ),
            SizedBox(height: 14.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Try again',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WallpaperAssetTile extends StatelessWidget {
  const _WallpaperAssetTile({required this.asset, required this.onTap});

  final AssetEntity asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: FutureBuilder<Uint8List?>(
          future: asset.thumbnailDataWithSize(const ThumbnailSize.square(300)),
          builder: (context, snapshot) {
            final bytes = snapshot.data;
            if (bytes == null) {
              return ColoredBox(color: AppColors.chipBg);
            }
            return Image.memory(bytes, fit: BoxFit.cover);
          },
        ),
      ),
    );
  }
}
