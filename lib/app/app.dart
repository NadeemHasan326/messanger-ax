import 'package:messanger_ax/exports.dart';

class MessangerApp extends StatelessWidget {
  const MessangerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppConstants.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return Obx(() {
          final themeMode = ThemeController.to.themeMode;
          return GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
            defaultTransition: AppNavigation.pushTransition,
            transitionDuration: AppNavigation.transitionDuration,
            popGesture: GetPlatform.isIOS || GetPlatform.isMacOS,
            builder: (context, child) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                behavior: HitTestBehavior.translucent,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        });
      },
    );
  }
}
