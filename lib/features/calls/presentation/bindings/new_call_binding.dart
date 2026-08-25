import 'package:messanger_ax/exports.dart';

class NewCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewCallController>(NewCallController.new);
  }
}
