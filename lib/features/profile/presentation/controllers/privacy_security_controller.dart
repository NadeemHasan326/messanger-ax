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

  ProfileController get _profile => Get.find<ProfileController>();

  Rx<DisappearingDuration> get disappearingDuration =>
      _profile.disappearingDuration;

  Future<void> pickDisappearingDuration() =>
      _profile.pickDisappearingDuration();

  String get disappearingLabel => disappearingDuration.value.label;

  String get disappearingSubtitle =>
      disappearingDuration.value == DisappearingDuration.off
          ? 'New messages stay until you delete them'
          : 'New messages vanish after ${disappearingDuration.value.label}';

  RxBool get replyAllowed => _profile.replyAllowed;

  void toggleReplies(bool value) => _profile.setReplyAllowed(value);

  RxBool get screenshotBlocked => _profile.screenshotBlocked;

  void toggleScreenshotBlocked(bool value) =>
      _profile.setScreenshotBlocked(value);

  RxBool get screenshotAlerts => _profile.screenshotAlerts;

  void toggleScreenshotAlerts(bool value) =>
      _profile.setScreenshotAlerts(value);

  RxBool get readReceipts => _profile.readReceipts;

  void toggleReadReceipts(bool value) => _profile.readReceipts.value = value;

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
