import 'package:messanger_ax/exports.dart';

class AddContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddContactController>(AddContactController.new);
  }
}
