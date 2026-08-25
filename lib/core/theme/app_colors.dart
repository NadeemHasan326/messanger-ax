import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger_ax/core/theme/theme_controller.dart';

class AppColors {
  AppColors._();

  static bool get isDark {
    if (!Get.isRegistered<ThemeController>()) return false;
    return ThemeController.to.isDark.value;
  }

  static Color _tone(Color light, Color dark) => isDark ? dark : light;

  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primarySoft = Color(0xFF0EA5E9);
  static const Color primaryGlow = Color(0x331A73E8);
  static const Color black = Color(0xff000000);

  /// Brand navy that stays dark (gradients, story colors, in-call UI).
  static const Color ink = Color(0xFF0D1B3E);

  static Color get background =>
      _tone(const Color(0xFFF5F7FB), const Color(0xFF0B1220));
  static Color get surface =>
      _tone(const Color(0xFFFFFFFF), const Color(0xFF152033));
  static const Color white = Color(0xFFFFFFFF);

  static Color get navy =>
      _tone(ink, const Color(0xFFF1F5FF));
  static Color get label =>
      _tone(const Color(0xFF1A2A47), const Color(0xFFE8EEF8));
  static Color get muted =>
      _tone(const Color(0xFF8F9BB3), const Color(0xFF9AA6BC));
  static Color get hint =>
      _tone(const Color(0xFFB0B8C8), const Color(0xFF7B8699));
  static Color get icon =>
      _tone(const Color(0xFF9AA3B5), const Color(0xFF8B96AA));

  static Color get avatarBg =>
      _tone(const Color(0xFFD6E8FF), const Color(0xFF1E3A5F));
  static Color get logoBg =>
      _tone(const Color(0xFFDCEBFF), const Color(0xFF1A3358));
  static Color get checkboxBorder =>
      _tone(const Color(0xFFC5CDD9), const Color(0xFF3D4A5C));
  static Color get chipBg =>
      _tone(const Color(0xFFF0F3F8), const Color(0xFF1E293B));
  static Color get divider =>
      _tone(const Color(0xFFE8ECF2), const Color(0xFF2A3548));

  static Color get shadow =>
      _tone(const Color(0x1A0D1B3E), const Color(0x66000000));
  static Color get softShadow =>
      _tone(const Color(0x0A0D1B3E), const Color(0x33000000));
  static const Color buttonShadow = Color(0x4D1A73E8);

  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  static const Color avatarBlue = Color(0xFF5B8DEF);
  static const Color avatarViolet = Color(0xFF7C6CF0);
  static const Color avatarTeal = Color(0xFF4DB6AC);
  static const Color avatarCoral = Color(0xFFFF8A65);
  static const Color avatarGreen = Color(0xFF66BB6A);
  static const Color avatarSky = Color(0xFF42A5F5);

  static const List<Color> avatarPalette = [
    avatarBlue,
    avatarViolet,
    avatarTeal,
    avatarCoral,
    avatarGreen,
    avatarSky,
  ];
}
