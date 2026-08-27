import 'package:messanger_ax/exports.dart';

class CreateChannelBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<CreateChannelController>()) {
      Get.delete<CreateChannelController>(force: true);
    }
    Get.put(CreateChannelController());
  }
}
