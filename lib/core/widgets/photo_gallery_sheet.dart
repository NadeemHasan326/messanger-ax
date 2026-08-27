import 'package:messanger_ax/exports.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoGallerySheet {
  PhotoGallerySheet._();

  static Future<Uint8List?> pick({String title = 'Choose photo'}) {
    return Get.bottomSheet<Uint8List>(
      _PhotoGallerySheet(title: title),
      isScrollControlled: true,
    );
  }
}

class _PhotoGallerySheet extends StatefulWidget {
  const _PhotoGallerySheet({required this.title});

  final String title;

  @override
  State<_PhotoGallerySheet> createState() => _PhotoGallerySheetState();
}

class _PhotoGallerySheetState extends State<_PhotoGallerySheet> {
  var _loading = true;
  String? _error;
  List<AssetEntity> _assets = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) {
        setState(() {
          _loading = false;
          _error = 'Photo access is required to choose a picture.';
        });
        return;
      }
      final paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      if (paths.isEmpty) {
        setState(() {
          _loading = false;
          _assets = const [];
        });
        return;
      }
      final assets = await paths.first.getAssetListPaged(page: 0, size: 120);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _assets = assets;
      });
    } on MissingPluginException {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Gallery is not ready yet. Restart the app and try again.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load photos from your gallery.';
      });
    }
  }

  Future<void> _select(AssetEntity asset) async {
    try {
      final bytes = await asset.thumbnailDataWithSize(
        const ThumbnailSize.square(800),
      );
      if (bytes == null || bytes.isEmpty) {
        AppToast.error('Could not load that photo');
        return;
      }
      Get.back(result: bytes);
    } catch (_) {
      AppToast.error('Could not use that photo');
    }
  }

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
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(child: _body()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _GalleryState(message: _error!, onRetry: _load);
    }
    if (_assets.isEmpty) {
      return _GalleryState(
        message: 'No photos found on this device.',
        onRetry: _load,
      );
    }
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: _assets.length,
      itemBuilder: (_, index) {
        final asset = _assets[index];
        return GestureDetector(
          onTap: () => _select(asset),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: FutureBuilder<Uint8List?>(
              future: asset.thumbnailDataWithSize(
                const ThumbnailSize.square(300),
              ),
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
      },
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
