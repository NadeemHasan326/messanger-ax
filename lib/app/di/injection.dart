import 'package:messanger_ax/exports.dart';

/// Registers app-wide GetX dependencies (services, repositories, etc.).
///
/// Feature-scoped controllers belong in feature [Bindings], not here.
Future<void> configureDependencies() async {
  Get.put(ThemeController(), permanent: true);
}
