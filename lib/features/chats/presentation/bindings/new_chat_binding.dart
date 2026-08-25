import 'package:messanger_ax/exports.dart';

class NewChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewChatController>(NewChatController.new);
  }
}
