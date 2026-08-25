import 'package:messanger_ax/exports.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountController>(AccountController.new);
  }
}
