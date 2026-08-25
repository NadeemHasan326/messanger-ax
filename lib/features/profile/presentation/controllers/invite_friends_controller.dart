import 'package:messanger_ax/exports.dart';

class InviteFriendsController extends GetxController {
  final inviteCode = 'NADEEM8';
  final inviteLink = 'https://messangerax.app/invite/NADEEM8';

  final suggested = const [
    ContactItem(name: 'Alex Rivera', role: 'Product Manager', section: 'A'),
    ContactItem(name: 'Ava Thompson', role: 'UX Designer', section: 'A'),
    ContactItem(name: 'Benjamin Lee', role: 'iOS Engineer', section: 'B'),
    ContactItem(name: 'Chloe Martinez', role: 'Marketing Lead', section: 'C'),
  ];

  final invitedNames = <String>[].obs;

  String get shareMessage =>
      'Join me on Messanger AX! Use my invite code $inviteCode or open $inviteLink';

  bool isInvited(String name) => invitedNames.contains(name);

  Future<void> copyLink() async {
    await Clipboard.setData(ClipboardData(text: inviteLink));
    AppToast.success('Invite link copied');
  }

  Future<void> copyCode() async {
    await Clipboard.setData(ClipboardData(text: inviteCode));
    AppToast.success('Invite code copied');
  }

  Future<void> copyMessage() async {
    await Clipboard.setData(ClipboardData(text: shareMessage));
    AppToast.success('Invite message copied');
  }

  void inviteContact(ContactItem contact) {
    if (isInvited(contact.name)) return;
    invitedNames.add(contact.name);
    AppToast.success('Invite sent to ${contact.name}');
  }
}
