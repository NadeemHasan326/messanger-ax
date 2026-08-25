import 'package:messanger_ax/exports.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(ForgotPasswordController.new);
  }
}
