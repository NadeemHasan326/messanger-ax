import 'package:messanger_ax/exports.dart';

class CreateAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAccountController>(CreateAccountController.new);
  }
}
