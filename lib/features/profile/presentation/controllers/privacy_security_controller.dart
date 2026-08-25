import 'package:messanger_ax/exports.dart';

class BlockedContact {
  const BlockedContact({required this.name, required this.blockedOn});

  final String name;
  final String blockedOn;
}

class PrivacySecurityController extends GetxController {
  static const visibilityOptions = ['Everyone', 'My contacts', 'Nobody'];

  final lastSeen = 'My contacts'.obs;
  final profilePhoto = 'Everyone'.obs;
  final aboutVisibility = 'My contacts'.obs;
  final statusVisibility = 'My contacts'.obs;
  final readReceipts = true.obs;
  final twoStepVerification = false.obs;
  final screenLock = false.obs;
  final loginAlerts = true.obs;

  final blocked = <BlockedContact>[
    const BlockedContact(name: 'Jordan Hale', blockedOn: '12 Aug 2026'),
    const BlockedContact(name: 'Riley Chen', blockedOn: '3 Jul 2026'),
  ].obs;

  Future<void> pickVisibility(String title, RxString value) async {
    final selected = await SettingsOptionSheet.show(
      title: title,
      options: visibilityOptions,
      selected: value.value,
    );
    if (selected != null) value.value = selected;
  }

  void toggleReadReceipts(bool value) => readReceipts.value = value;

  void toggleTwoStep(bool value) {
    twoStepVerification.value = value;
    AppToast.info(
      value
          ? 'Two-step verification is on'
          : 'Two-step verification is off',
    );
  }

  void toggleScreenLock(bool value) => screenLock.value = value;

  void toggleLoginAlerts(bool value) => loginAlerts.value = value;

  void unblock(BlockedContact contact) {
    blocked.remove(contact);
    AppToast.success('Unblocked ${contact.name}');
  }
}
