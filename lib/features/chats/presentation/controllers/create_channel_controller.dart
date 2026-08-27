import 'package:messanger_ax/exports.dart';

class CreateChannelController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final name = ''.obs;
  final description = ''.obs;
  final nameError = RxnString();
  final isLoading = false.obs;
  final avatarBytes = Rxn<Uint8List>();

  ChatsController get _chats => Get.find<ChatsController>();

  bool get canCreate => name.value.trim().length >= 2 && !isLoading.value;

  Future<void> pickAvatar() async {
    final bytes = await PhotoGallerySheet.pick(title: 'Channel photo');
    if (bytes != null) avatarBytes.value = bytes;
  }

  void onNameChanged(String value) {
    name.value = value.trim();
    nameError.value = null;
  }

  void onDescriptionChanged(String value) => description.value = value.trim();

  Future<void> createChannel() async {
    final trimmedName = nameController.text.trim();
    if (trimmedName.length < 2) {
      nameError.value = 'Enter a channel name';
      return;
    }
    if (_chats.channelNameTaken(trimmedName)) {
      nameError.value = 'That name is already taken';
      return;
    }

    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final channel = _chats.createChannel(
      name: trimmedName,
      description: descriptionController.text.trim(),
    );
    isLoading.value = false;

    if (channel == null) {
      nameError.value = 'That name is already taken';
      return;
    }

    AppToast.success('Channel "$trimmedName" created');
    AppNavigation.back();
    ChatNavigation.open(
      name: channel.name,
      isChannel: true,
      showCallOption: false,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
