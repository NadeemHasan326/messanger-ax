import 'package:messanger_ax/exports.dart';

class MainShellPage extends GetView<MainController> {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        ThemeController.to.isDark.value;
        return Scaffold(
          backgroundColor: AppColors.background,
          extendBody: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 72.h),
                  child: IndexedStack(
                    index: controller.currentIndex.value,
                    children: [
                      ChatsPage(),
                      SearchPage(),
                      CallsPage(),
                      NotificationsPage(),
                      ProfilePage(),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 18.w,
                right: 18.w,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: FloatingBottomNav(
                    currentIndex: controller.currentIndex.value,
                    notificationBadge: 3,
                    onTap: controller.changeTab,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
