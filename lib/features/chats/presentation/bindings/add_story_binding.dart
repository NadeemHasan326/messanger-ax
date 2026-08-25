import 'package:messanger_ax/exports.dart';

class AddStoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddStoryController>(AddStoryController.new, fenix: true);
  }
}
