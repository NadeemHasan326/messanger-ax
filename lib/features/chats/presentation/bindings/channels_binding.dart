import 'package:messanger_ax/exports.dart';

class ChannelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChannelsController>(ChannelsController.new);
  }
}
