import 'package:messanger_ax/exports.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationController>(OtpVerificationController.new);
  }
}
