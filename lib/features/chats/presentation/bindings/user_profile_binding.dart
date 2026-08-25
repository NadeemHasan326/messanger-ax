import 'package:messanger_ax/exports.dart';

class UserProfileBinding extends Bindings {
  @override
  void dependencies() {
    final name = Get.arguments as String?;
    Get.put(UserProfileController(userName: name));
  }
}
