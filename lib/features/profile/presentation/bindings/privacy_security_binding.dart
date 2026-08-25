import 'package:messanger_ax/exports.dart';

class PrivacySecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacySecurityController>(PrivacySecurityController.new);
  }
}
