import 'package:messanger_ax/exports.dart';

class ChannelInfoBinding extends Bindings {
  @override
  void dependencies() {
    final name = Get.arguments as String? ?? '';
    Get.put(ChannelInfoController(channelName: name));
  }
}
