import 'package:messanger_ax/exports.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(MainController.new);
    Get.lazyPut<ChatsController>(ChatsController.new);
    Get.lazyPut<SearchPageController>(SearchPageController.new);
    Get.lazyPut<ContactsController>(ContactsController.new);
    Get.lazyPut<CallsController>(CallsController.new);
    Get.lazyPut<NotificationsController>(NotificationsController.new);
    Get.lazyPut<ProfileController>(ProfileController.new);
  }
}
