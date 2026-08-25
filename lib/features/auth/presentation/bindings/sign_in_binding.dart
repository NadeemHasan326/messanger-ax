import 'package:messanger_ax/exports.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(SignInController.new);
  }
}
