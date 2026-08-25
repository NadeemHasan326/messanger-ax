import 'package:messanger_ax/exports.dart';

/// Central navigation helper with platform-aware transitions.
class AppNavigation {
  AppNavigation._();

  static const transitionDuration = Duration(milliseconds: 320);

  /// iOS-style slide from the right; material slide on other platforms.
  static Transition get pushTransition =>
      GetPlatform.isIOS || GetPlatform.isMacOS
          ? Transition.cupertino
          : Transition.rightToLeft;

  static Transition get resetTransition => Transition.fadeIn;

  static Future<T?>? push<T>(
    String route, {
    dynamic arguments,
  }) {
    return Get.toNamed<T>(
      route,
      arguments: arguments,
    );
  }

  static Future<T?>? resetTo<T>(
    String route, {
    dynamic arguments,
  }) {
    return Get.offAllNamed<T>(
      route,
      arguments: arguments,
    );
  }

  static void back<T>([T? result]) => Get.back<T>(result: result);
}
