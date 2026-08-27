import 'package:messanger_ax/exports.dart';

abstract final class ChatWallpaperStyle {
  static Color color(ChatWallpaper wallpaper) {
    return switch (wallpaper) {
      ChatWallpaper.system || ChatWallpaper.gallery => AppColors.background,
      ChatWallpaper.dusk => AppColors.isDark
          ? const Color(0xFF1B2438)
          : const Color(0xFFD9E3F5),
      ChatWallpaper.sage => AppColors.isDark
          ? const Color(0xFF1A2E28)
          : const Color(0xFFD7E8DC),
      ChatWallpaper.sand => AppColors.isDark
          ? const Color(0xFF2C261C)
          : const Color(0xFFF3E6D4),
      ChatWallpaper.slate => AppColors.isDark
          ? const Color(0xFF1C2430)
          : const Color(0xFFD5DCE6),
      ChatWallpaper.mist => AppColors.isDark
          ? const Color(0xFF15202B)
          : const Color(0xFFE4EEF6),
    };
  }

  static BoxDecoration decoration(
    ChatWallpaper wallpaper, {
    Uint8List? imageBytes,
  }) {
    if (wallpaper == ChatWallpaper.gallery && imageBytes != null) {
      return BoxDecoration(
        color: AppColors.background,
        image: DecorationImage(
          image: MemoryImage(imageBytes),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.black.withValues(alpha: AppColors.isDark ? 0.42 : 0.16),
            BlendMode.darken,
          ),
        ),
      );
    }

    final base = color(wallpaper);
    if (wallpaper == ChatWallpaper.system ||
        wallpaper == ChatWallpaper.gallery) {
      return BoxDecoration(color: base);
    }
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          base,
          Color.lerp(
            base,
            AppColors.primary,
            AppColors.isDark ? 0.14 : 0.08,
          )!,
        ],
      ),
    );
  }
}
