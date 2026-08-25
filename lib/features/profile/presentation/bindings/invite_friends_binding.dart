import 'package:messanger_ax/exports.dart';

class InviteFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InviteFriendsController>(InviteFriendsController.new);
  }
}
