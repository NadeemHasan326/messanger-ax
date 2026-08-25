import 'package:messanger_ax/exports.dart';

abstract final class ProfileNavigation {
  static Future<T?>? openAccount<T>() =>
      AppNavigation.push<T>(AppRoutes.account);

  static Future<T?>? open<T>(String route) => AppNavigation.push<T>(route);
}
