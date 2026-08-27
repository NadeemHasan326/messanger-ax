import 'package:messanger_ax/exports.dart';
import 'package:photo_manager/photo_manager.dart';

class ProfileController extends GetxController {
  final name = 'Nadeem Hasan'.obs;
  final username = 'nadeemhasan'.obs;
  final email = 'nadeem@virexon.com'.obs;
  final phone = '9876543210'.obs;
  final about = 'Hey there! I am using Messanger AX.'.obs;
  final status = 'Available'.obs;
  final notificationsEnabled = true.obs;
  final disappearingDuration = DisappearingDuration.off.obs;
  final replyAllowed = true.obs;
  final screenshotBlocked = false.obs;
  final screenshotAlerts = true.obs;
  final chatWallpaper = ChatWallpaper.system.obs;
  final wallpaperImage = Rxn<Uint8List>();
  final wallpaperAssets = <AssetEntity>[].obs;
  final wallpaperGalleryLoading = false.obs;
  final wallpaperGalleryError = RxnString();
  final readReceipts = true.obs;

  @override
  void onInit() {
    super.onInit();
    ScreenCapture.listen(_onScreenshot);
    ScreenCapture.setBlocked(screenshotBlocked.value);
    ever(screenshotBlocked, (blocked) {
      ScreenCapture.setBlocked(blocked);
    });
  }

  @override
  void onClose() {
    ScreenCapture.stopListening();
    super.onClose();
  }

  void _onScreenshot() {
    if (!screenshotAlerts.value) return;
    if (Get.isRegistered<ChatController>()) {
      Get.find<ChatController>().onScreenshotTaken();
      return;
    }
    if (Get.isRegistered<StoryViewerController>()) {
      AppToast.warning(
        'A screenshot was taken of this status',
        position: AppToastPosition.top,
      );
      return;
    }
    AppToast.warning('Screenshot taken');
  }

  List<ProfileMenuItem> get menu => [
    const ProfileMenuItem(
      icon: Icons.person_outline_rounded,
      title: 'Account',
      subtitle: 'Profile, phone, email',
      route: AppRoutes.account,
    ),
    const ProfileMenuItem(
      icon: Icons.lock_outline_rounded,
      title: 'Privacy & Security',
      subtitle: 'Blocked contacts, 2FA',
      route: AppRoutes.privacySecurity,
    ),
    ProfileMenuItem(
      icon: Icons.timer_outlined,
      title: 'Disappearing messages',
      subtitle: disappearingDuration.value == DisappearingDuration.off
          ? 'Off · 24 hours, 7 days, and more'
          : 'New messages vanish after ${disappearingDuration.value.label}',
    ),
    const ProfileMenuItem(
      icon: Icons.palette_outlined,
      title: 'Appearance',
      subtitle: 'Light and dark theme',
      showThemeToggle: true,
    ),
    ProfileMenuItem(
      icon: Icons.wallpaper_rounded,
      title: 'Chat wallpaper',
      subtitle: wallpaperSubtitle,
    ),
    const ProfileMenuItem(
      icon: Icons.notifications_none_rounded,
      title: 'Notifications',
      subtitle: 'Message & call alerts',
      showNotificationToggle: true,
    ),
    const ProfileMenuItem(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Contact us',
      subtitle: 'Chat with the Messanger AX team',
    ),
    const ProfileMenuItem(
      icon: Icons.person_add_alt_1_outlined,
      title: 'Invite Friends',
      subtitle: 'Share Messanger AX',
      route: AppRoutes.inviteFriends,
    ),
    const ProfileMenuItem(
      icon: Icons.description_outlined,
      title: 'Terms of Service',
      subtitle: 'Rules and conditions of use',
    ),
    const ProfileMenuItem(
      icon: Icons.privacy_tip_outlined,
      title: 'Privacy Policy',
      subtitle: 'How we handle your data',
    ),
  ];

  void openMenu(ProfileMenuItem item) {
    if (item.showThemeToggle || item.showNotificationToggle) return;
    switch (item.title) {
      case 'Disappearing messages':
        pickDisappearingDuration();
        return;
      case 'Chat wallpaper':
        pickChatWallpaper();
        return;
      case 'Contact us':
        contactUs();
        return;
      case 'Terms of Service':
        openTerms();
        return;
      case 'Privacy Policy':
        openPrivacyPolicy();
        return;
    }
    if (item.route == null) return;
    ProfileNavigation.open(item.route!);
  }

  void toggleNotifications() {
    notificationsEnabled.toggle();
  }

  Future<void> pickDisappearingDuration() async {
    final selected = await SettingsOptionSheet.show(
      title: 'Disappearing messages',
      options: DisappearingDuration.values.map((d) => d.label).toList(),
      selected: disappearingDuration.value.label,
    );
    if (selected == null) return;
    disappearingDuration.value = DisappearingDuration.values.firstWhere(
      (d) => d.label == selected,
    );
  }

  String get wallpaperSubtitle {
    if (chatWallpaper.value == ChatWallpaper.gallery &&
        wallpaperImage.value != null) {
      return 'Photo from gallery';
    }
    return chatWallpaper.value.label;
  }

  Future<void> pickChatWallpaper() async {
    final selected = await SettingsOptionSheet.show(
      title: 'Chat wallpaper',
      options: ChatWallpaper.values.map((w) => w.label).toList(),
      selected: chatWallpaper.value.label,
    );
    if (selected == null) return;
    if (selected == ChatWallpaper.gallery.label) {
      await pickGalleryWallpaper();
      return;
    }
    chatWallpaper.value = ChatWallpaper.values.firstWhere(
      (w) => w.label == selected,
    );
    wallpaperImage.value = null;
  }

  Future<void> pickGalleryWallpaper() async {
    await loadWallpaperGallery();
    await WallpaperGallerySheet.show();
  }

  Future<void> loadWallpaperGallery() async {
    wallpaperGalleryLoading.value = true;
    wallpaperGalleryError.value = null;
    wallpaperAssets.clear();
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) {
        wallpaperGalleryError.value =
            'Photo access is required to choose a chat wallpaper.';
        return;
      }
      final paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      if (paths.isEmpty) return;
      final assets = await paths.first.getAssetListPaged(page: 0, size: 120);
      wallpaperAssets.assignAll(assets);
    } on MissingPluginException {
      wallpaperGalleryError.value =
          'Gallery is not ready yet. Restart the app and try again.';
    } catch (_) {
      wallpaperGalleryError.value = 'Could not load photos from your gallery.';
    } finally {
      wallpaperGalleryLoading.value = false;
    }
  }

  Future<void> applyWallpaperAsset(AssetEntity asset) async {
    try {
      final bytes = await asset.thumbnailDataWithSize(
        const ThumbnailSize(1600, 1600),
      );
      if (bytes == null || bytes.isEmpty) {
        AppToast.error('Could not load that photo');
        return;
      }
      wallpaperImage.value = bytes;
      chatWallpaper.value = ChatWallpaper.gallery;
      wallpaperAssets.clear();
      Get.back();
    } catch (_) {
      AppToast.error('Could not use that photo');
    }
  }

  void setReplyAllowed(bool value) => replyAllowed.value = value;

  void setScreenshotBlocked(bool value) {
    screenshotBlocked.value = value;
    AppToast.info(
      value ? 'Screenshots are blocked' : 'Screenshots are allowed',
    );
  }

  void setScreenshotAlerts(bool value) => screenshotAlerts.value = value;

  void contactUs() {
    ChatNavigation.open(
      name: 'Messanger AX Support',
      online: true,
      showCallOption: false,
    );
  }

  void openAccount() => ProfileNavigation.openAccount();

  static const appVersion = '1.0.0';

  void openTerms() {
    _openLegal(
      'Terms of Service',
      'By using Messanger AX you agree to use the app lawfully, respect other users, '
          'and keep your account secure. We may update these terms and will notify you '
          'of material changes in the app.',
    );
  }

  void openPrivacyPolicy() {
    _openLegal(
      'Privacy Policy',
      'We collect the account details you provide (name, email, phone) to operate '
          'messaging and calls. Message content in personal chats is end-to-end encrypted. '
          'You can request account deletion from Profile at any time.',
    );
  }

  void _openLegal(String title, String body) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            body,
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.5,
              color: AppColors.muted,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logout() {
    PremiumConfirmDialog.show(
      title: 'Log Out',
      message: 'Are you sure you want to log out of Messanger AX?',
      confirmLabel: 'Log Out',
      icon: Icons.logout_rounded,
      accentColor: AppColors.primary,
      onConfirm: () {
        AppNavigation.resetTo(AppRoutes.signIn);
        AppToast.info('Logged out');
      },
    );
  }

  void deleteAccount() {
    PremiumConfirmDialog.show(
      title: 'Delete Account',
      message:
          'This will permanently delete your account and all data. This action cannot be undone.',
      confirmLabel: 'Delete',
      icon: Icons.delete_outline_rounded,
      accentColor: AppColors.error,
      onConfirm: () {
        AppNavigation.resetTo(AppRoutes.signIn);
        AppToast.info('Account deleted');
      },
    );
  }
}
