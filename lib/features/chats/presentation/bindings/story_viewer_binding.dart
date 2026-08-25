import 'package:messanger_ax/exports.dart';

class StoryViewerBinding extends Bindings {
  @override
  void dependencies() {
    final name = Get.arguments as String?;
    Get.put(StoryViewerController(initialUserName: name));
  }
}
