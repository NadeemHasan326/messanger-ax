import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final isDark = false.obs;

  ThemeMode get themeMode =>
      isDark.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _syncSystemUi();
  }

  void toggle() {
    isDark.toggle();
    Get.changeThemeMode(themeMode);
    _syncSystemUi();
    HapticFeedback.lightImpact();
  }

  void _syncSystemUi() {
    final overlay = isDark.value
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: const Color(0xFF0B1220),
            systemNavigationBarIconBrightness: Brightness.light,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: const Color(0xFFF5F7FB),
            systemNavigationBarIconBrightness: Brightness.dark,
          );
    SystemChrome.setSystemUIOverlayStyle(overlay);
  }
}
