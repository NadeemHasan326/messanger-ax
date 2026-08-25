import 'package:messanger_ax/exports.dart';

class ProfileController extends GetxController {
  final name = 'Nadeem Hasan'.obs;
  final username = 'nadeemhasan'.obs;
  final email = 'nadeem@virexon.com'.obs;
  final phone = '9876543210'.obs;
  final about = 'Hey there! I am using Messanger AX.'.obs;
  final status = 'Available'.obs;
  final notificationsEnabled = true.obs;

  final menu = const [
    ProfileMenuItem(
      icon: Icons.person_outline_rounded,
      title: 'Account',
      subtitle: 'Profile, phone, email',
      route: AppRoutes.account,
    ),
    ProfileMenuItem(
      icon: Icons.lock_outline_rounded,
      title: 'Privacy & Security',
      subtitle: 'Blocked contacts, 2FA',
      route: AppRoutes.privacySecurity,
    ),
    ProfileMenuItem(
      icon: Icons.palette_outlined,
      title: 'Appearance',
      subtitle: 'Light and dark theme',
      showThemeToggle: true,
    ),
    ProfileMenuItem(
      icon: Icons.notifications_none_rounded,
      title: 'Notifications',
      subtitle: 'Message & call alerts',
      showNotificationToggle: true,
    ),
    ProfileMenuItem(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Contact us',
      subtitle: 'Chat with the Messanger AX team',
    ),
    ProfileMenuItem(
      icon: Icons.person_add_alt_1_outlined,
      title: 'Invite Friends',
      subtitle: 'Share Messanger AX',
      route: AppRoutes.inviteFriends,
    ),
    ProfileMenuItem(
      icon: Icons.description_outlined,
      title: 'Terms of Service',
      subtitle: 'Rules and conditions of use',
    ),
    ProfileMenuItem(
      icon: Icons.privacy_tip_outlined,
      title: 'Privacy Policy',
      subtitle: 'How we handle your data',
    ),
  ];

  void openMenu(ProfileMenuItem item) {
    if (item.showThemeToggle || item.showNotificationToggle) return;
    switch (item.title) {
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
