import 'package:messanger_ax/exports.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final textTheme = GoogleFonts.poppinsTextTheme();
    const background = Color(0xFFF5F7FB);
    const surface = Color(0xFFFFFFFF);
    const onSurface = AppColors.ink;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: surface,
        brightness: Brightness.light,
      ),
      textTheme: textTheme.apply(
        bodyColor: onSurface,
        displayColor: onSurface,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: surface,
        foregroundColor: onSurface,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: onSurface, size: 22),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: Color(0xFFC5CDD9), width: 1.5),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return surface;
        }),
      ),
    );
  }

  static ThemeData get dark {
    final textTheme = GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme);
    const onSurface = Color(0xFFF1F5FF);
    const background = Color(0xFF0B1220);
    const surface = Color(0xFF152033);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: surface,
        brightness: Brightness.dark,
      ),
      textTheme: textTheme.apply(
        bodyColor: onSurface,
        displayColor: onSurface,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: surface,
        foregroundColor: onSurface,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: onSurface, size: 22),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: Color(0xFF3D4A5C), width: 1.5),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return surface;
        }),
      ),
    );
  }
}
