import 'package:messanger_ax/exports.dart';
import 'package:messanger_ax/features/chats/data/mock_story_contacts.dart';
import 'package:messanger_ax/features/chats/domain/story_visibility.dart';
import 'package:photo_manager/photo_manager.dart';

class AddStoryController extends GetxController {
  final type = Rxn<StoryType>();
  final textController = TextEditingController();
  final captionController = TextEditingController();
  final contactSearchController = TextEditingController();

  final selectedColor = Rx<Color>(AppColors.primary);
  final privacy = StoryPrivacy.everyone.obs;
  final mediaCaptured = false.obs;
  final formTick = 0.obs;
  final contactQuery = ''.obs;
  final selectedContacts = <String>{}.obs;

  final galleryAssets = <AssetEntity>[].obs;
  final galleryLoading = false.obs;
  final galleryPermissionDenied = false.obs;
  final galleryErrorMessage = RxnString();
  final selectedAsset = Rxn<AssetEntity>();
  final selectedImageBytes = Rxn<Uint8List>();

  static const contacts = MockStoryContacts.all;

  static const backgroundColors = [
    AppColors.primary,
    AppColors.avatarViolet,
    AppColors.avatarTeal,
    AppColors.avatarCoral,
    AppColors.avatarGreen,
    AppColors.ink,
  ];

  void selectType(StoryType storyType) {
    type.value = storyType;
    if (storyType != StoryType.text) {
      _clearMediaSelection();
    }
    if (storyType == StoryType.gallery) {
      loadGalleryImages();
    }
  }

  Future<void> loadGalleryImages() async {
    galleryLoading.value = true;
    galleryPermissionDenied.value = false;
    galleryErrorMessage.value = null;
    galleryAssets.clear();

    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) {
        galleryLoading.value = false;
        galleryPermissionDenied.value = true;
        galleryErrorMessage.value =
            'Photo access is required to pick images from your gallery.';
        return;
      }

      final paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      if (paths.isEmpty) {
        galleryLoading.value = false;
        return;
      }

      final assets = await paths.first.getAssetListPaged(page: 0, size: 120);
      galleryAssets.assignAll(assets);
    } on MissingPluginException {
      galleryPermissionDenied.value = true;
      galleryErrorMessage.value =
          'Gallery is not ready yet. Stop the app completely, then run it again (not hot reload).';
      AppToast.warning('Restart the app to enable gallery');
    } catch (_) {
      galleryPermissionDenied.value = true;
      galleryErrorMessage.value = 'Could not load photos from your gallery.';
      AppToast.error('Could not load gallery photos');
    } finally {
      galleryLoading.value = false;
    }
  }

  Future<void> selectGalleryAsset(AssetEntity asset) async {
    try {
      selectedAsset.value = asset;
      mediaCaptured.value = true;

      final bytes = await asset.thumbnailDataWithSize(
        const ThumbnailSize(1200, 1200),
      );
      selectedImageBytes.value = bytes;
      formTick.value++;
    } on MissingPluginException {
      AppToast.warning('Restart the app to enable gallery');
    } catch (_) {
      AppToast.error('Could not load the selected photo');
    }
  }

  void clearGallerySelection() => _clearMediaSelection();

  void _clearMediaSelection() {
    mediaCaptured.value = false;
    selectedAsset.value = null;
    selectedImageBytes.value = null;
  }

  void captureMedia() {
    mediaCaptured.value = true;
    AppToast.info('Photo captured');
  }

  List<StoryContact> get filteredContacts {
    final q = contactQuery.value.toLowerCase();
    if (q.isEmpty) return contacts;
    return contacts
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(q) ||
              contact.role.toLowerCase().contains(q),
        )
        .toList();
  }

  void onContactQueryChanged(String value) => contactQuery.value = value.trim();

  void toggleContact(StoryContact contact) {
    if (selectedContacts.contains(contact.name)) {
      selectedContacts.remove(contact.name);
    } else {
      selectedContacts.add(contact.name);
    }
    selectedContacts.refresh();
    formTick.value++;
  }

  bool isContactSelected(StoryContact contact) =>
      selectedContacts.contains(contact.name);

  bool get canPost {
    final _ = formTick.value;
    final storyType = type.value;
    if (storyType == null) return false;
    if (privacy.value == StoryPrivacy.selected && selectedContacts.isEmpty) {
      return false;
    }
    return switch (storyType) {
      StoryType.text => textController.text.trim().isNotEmpty,
      StoryType.camera => mediaCaptured.value,
      StoryType.gallery => selectedAsset.value != null,
    };
  }

  ProfileController get _profile => Get.find<ProfileController>();

  RxBool get screenshotBlocked => _profile.screenshotBlocked;

  RxBool get screenshotAlerts => _profile.screenshotAlerts;

  void setScreenshotBlocked(bool value) =>
      _profile.setScreenshotBlocked(value);

  void setScreenshotAlerts(bool value) =>
      _profile.setScreenshotAlerts(value);

  void setPrivacy(StoryPrivacy value) {
    privacy.value = value;
    if (value != StoryPrivacy.selected) {
      selectedContacts.clear();
      contactSearchController.clear();
      contactQuery.value = '';
    }
    formTick.value++;
  }

  void selectColor(Color color) => selectedColor.value = color;

  void onTextChanged(String _) => formTick.value++;

  void reset() {
    type.value = null;
    textController.clear();
    captionController.clear();
    contactSearchController.clear();
    contactQuery.value = '';
    selectedContacts.clear();
    selectedColor.value = AppColors.primary;
    privacy.value = StoryPrivacy.everyone;
    mediaCaptured.value = false;
    formTick.value = 0;
    galleryAssets.clear();
    galleryLoading.value = false;
    galleryPermissionDenied.value = false;
    galleryErrorMessage.value = null;
    selectedAsset.value = null;
    selectedImageBytes.value = null;
  }

  Future<void> postStory() async {
    if (privacy.value == StoryPrivacy.selected && selectedContacts.isEmpty) {
      AppToast.warning('Select at least one contact');
      return;
    }

    if (!canPost) {
      AppToast.warning(
        type.value == StoryType.text
            ? 'Write something for your status'
            : 'Add a photo first',
      );
      return;
    }

    final selectedNames = selectedContacts.toList()..sort();
    final viewerNames = StoryVisibility.resolveViewers(
      privacy: privacy.value,
      selectedContactNames: selectedNames,
    );

    final story = PostedStory(
      type: type.value!,
      privacy: privacy.value,
      caption: captionController.text.trim().isEmpty
          ? null
          : captionController.text.trim(),
      selectedContactNames: selectedNames,
      viewerNames: viewerNames,
    );

    Get.find<ChatsController>().markMyStatusPosted(story);
    AppToast.success(
      'Your status is live · ${story.visibilityLabel.toLowerCase()}',
    );
    AppNavigation.back();
  }

  @override
  void onClose() {
    textController.dispose();
    captionController.dispose();
    contactSearchController.dispose();
    super.onClose();
  }
}
