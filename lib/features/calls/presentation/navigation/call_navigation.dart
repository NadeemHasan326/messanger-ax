import 'package:messanger_ax/exports.dart';

abstract final class CallNavigation {
  static Future<T?>? start<T>({
    required String name,
    bool online = false,
  }) {
    if (Get.isRegistered<InCallController>()) {
      Get.delete<InCallController>(force: true);
    }
    return AppNavigation.push<T>(
      AppRoutes.inCall,
      arguments: CallSession(name: name, online: online),
    );
  }
}
