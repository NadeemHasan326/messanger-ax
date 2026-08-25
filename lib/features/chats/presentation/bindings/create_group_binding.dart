import 'package:messanger_ax/exports.dart';

class CreateGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateGroupController>(CreateGroupController.new);
  }
}
