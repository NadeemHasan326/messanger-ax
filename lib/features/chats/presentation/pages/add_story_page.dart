import 'package:messanger_ax/exports.dart';
import 'package:photo_manager/photo_manager.dart';

class AddStoryPage extends GetView<AddStoryController> {
  const AddStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 20.w, 8.h),
              child: Row(
                children: [
                  const AppBackButton(),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Status',
                          style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          'Create and share your update',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TypeSelector(),
                      SizedBox(height: 16.h),
                      if (controller.type.value != null) ...[
                        _CreateSection(
                          key: ValueKey(controller.type.value),
                          type: controller.type.value!,
                        ),
                        SizedBox(height: 16.h),
                        AuthTextField(
                          label: 'Caption',
                          hint: 'Add a caption (optional)',
                          controller: controller.captionController,
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'PRIVACY',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                            color: AppColors.label,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            _PrivacyChip(
                              label: 'Everyone',
                              selected: controller.privacy.value ==
                                  StoryPrivacy.everyone,
                              onTap: () =>
                                  controller.setPrivacy(StoryPrivacy.everyone),
                            ),
                            SizedBox(width: 8.w),
                            _PrivacyChip(
                              label: 'Contacts',
                              selected: controller.privacy.value ==
                                  StoryPrivacy.contacts,
                              onTap: () =>
                                  controller.setPrivacy(StoryPrivacy.contacts),
                            ),
                            SizedBox(width: 8.w),
                            _PrivacyChip(
                              label: 'Selected',
                              selected: controller.privacy.value ==
                                  StoryPrivacy.selected,
                              onTap: () =>
                                  controller.setPrivacy(StoryPrivacy.selected),
                            ),
                          ],
                        ),
                        if (controller.privacy.value ==
                            StoryPrivacy.selected) ...[
                          SizedBox(height: 12.h),
                          _SelectedContactsSection(),
                        ],
                        SizedBox(height: 16.h),
                        Obx(() {
                          return SettingsGroupCard(
                            title: 'Screenshots',
                            children: [
                              SettingsListTile(
                                title: 'Prevent screenshots',
                                subtitle: 'Block captures of this status',
                                switchValue:
                                    controller.screenshotBlocked.value,
                                onSwitchChanged:
                                    controller.setScreenshotBlocked,
                              ),
                              SettingsListTile(
                                title: 'Screenshot alerts',
                                subtitle:
                                    'Notify when someone takes a screenshot',
                                switchValue:
                                    controller.screenshotAlerts.value,
                                onSwitchChanged:
                                    controller.setScreenshotAlerts,
                              ),
                            ],
                          );
                        }),
                      ] else
                        Text(
                          'Select a status type above to get started',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: AppColors.muted,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () {
                if (controller.type.value == null) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0.h),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      top: BorderSide(color: AppColors.divider),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.softShadow,
                        blurRadius: 12.r,
                        offset: Offset(0, -2.h),
                      ),
                    ],
                  ),
                  child: AuthPrimaryButton(
                    label: 'Post Status',
                    onPressed: controller.canPost ? controller.postStory : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeSelector extends GetView<AddStoryController> {
  const _TypeSelector();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final selectedType = controller.type.value;
        return Row(
          children: [
            _TypeChip(
              icon: Icons.photo_camera_rounded,
              label: 'Camera',
              color: AppColors.primary,
              selected: selectedType == StoryType.camera,
              onTap: () => controller.selectType(StoryType.camera),
            ),
            SizedBox(width: 8.w),
            _TypeChip(
              icon: Icons.photo_library_rounded,
              label: 'Gallery',
              color: AppColors.avatarViolet,
              selected: selectedType == StoryType.gallery,
              onTap: () => controller.selectType(StoryType.gallery),
            ),
            SizedBox(width: 8.w),
            _TypeChip(
              icon: Icons.text_fields_rounded,
              label: 'Text',
              color: AppColors.avatarTeal,
              selected: selectedType == StoryType.text,
              onTap: () => controller.selectType(StoryType.text),
            ),
          ],
        );
      },
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.12) : AppColors.surface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: selected ? color : AppColors.divider,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? null
                : [
                    BoxShadow(
                      color: AppColors.softShadow,
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? color : AppColors.icon, size: 22.sp),
              SizedBox(height: 4.h),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: selected ? color : AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateSection extends GetView<AddStoryController> {
  const _CreateSection({super.key, required this.type});

  final StoryType type;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      StoryType.camera => _CameraSection(),
      StoryType.gallery => _GallerySection(),
      StoryType.text => _TextSection(),
    };
  }
}

class _CameraSection extends GetView<AddStoryController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Container(
            height: 180.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.navy,
              gradient: controller.mediaCaptured.value
                  ? const LinearGradient(
                      colors: [AppColors.primary, AppColors.avatarViolet],
                    )
                  : null,
            ),
            child: controller.mediaCaptured.value
                ? Icon(
                    Icons.check_circle_rounded,
                    size: 48.sp,
                    color: AppColors.white.withValues(alpha: 0.9),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera_rounded,
                        size: 40.sp,
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Camera preview',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: AppColors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => AuthPrimaryButton(
            label: controller.mediaCaptured.value ? 'Retake' : 'Capture',
            onPressed: controller.captureMedia,
          ),
        ),
      ],
    );
  }
}

class _GallerySection extends GetView<AddStoryController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.galleryLoading.value) {
        return SizedBox(
          height: 160.h,
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.galleryPermissionDenied.value) {
        return _GalleryMessage(
          icon: Icons.photo_library_outlined,
          message: controller.galleryErrorMessage.value ??
              'Photo access is required to pick images from your gallery.',
          actionLabel: 'Try Again',
          onAction: controller.loadGalleryImages,
        );
      }

      if (controller.galleryAssets.isEmpty) {
        return _GalleryMessage(
          icon: Icons.image_not_supported_outlined,
          message: 'No photos found on this device.',
          actionLabel: 'Refresh',
          onAction: controller.loadGalleryImages,
        );
      }

      if (controller.selectedAsset.value != null) {
        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _SelectedGalleryImage(
                  asset: controller.selectedAsset.value!,
                  fallbackBytes: controller.selectedImageBytes.value,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            AuthPrimaryButton(
              label: 'Choose Another',
              onPressed: controller.clearGallerySelection,
            ),
          ],
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
        ),
        itemCount: controller.galleryAssets.length,
        itemBuilder: (_, index) {
          final asset = controller.galleryAssets[index];
          return _GalleryTile(
            asset: asset,
            onTap: () => controller.selectGalleryAsset(asset),
          );
        },
      );
    });
  }
}

class _GalleryMessage extends StatelessWidget {
  const _GalleryMessage({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36.sp, color: AppColors.muted),
          SizedBox(height: 10.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColors.muted,
            ),
          ),
          SizedBox(height: 12.h),
          AuthPrimaryButton(label: actionLabel, onPressed: onAction),
        ],
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({
    required this.asset,
    required this.onTap,
  });

  final AssetEntity asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: _AssetThumbnail(
          asset: asset,
          size: 300,
        ),
      ),
    );
  }
}

class _SelectedGalleryImage extends StatelessWidget {
  const _SelectedGalleryImage({
    required this.asset,
    this.fallbackBytes,
  });

  final AssetEntity asset;
  final Uint8List? fallbackBytes;

  @override
  Widget build(BuildContext context) {
    if (fallbackBytes != null) {
      return Image.memory(fallbackBytes!, fit: BoxFit.cover);
    }

    return _AssetThumbnail(
      asset: asset,
      size: 1200,
      fit: BoxFit.cover,
    );
  }
}

class _AssetThumbnail extends StatefulWidget {
  const _AssetThumbnail({
    required this.asset,
    required this.size,
    this.fit = BoxFit.cover,
  });

  final AssetEntity asset;
  final int size;
  final BoxFit fit;

  @override
  State<_AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<_AssetThumbnail> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bytes = await widget.asset.thumbnailDataWithSize(
      ThumbnailSize.square(widget.size),
    );
    if (!mounted) return;
    setState(() => _bytes = bytes);
  }

  @override
  Widget build(BuildContext context) {
    if (_bytes == null) {
      return Container(
        color: AppColors.divider.withValues(alpha: 0.35),
        child: const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Image.memory(_bytes!, fit: widget.fit);
  }
}

class _TextSection extends GetView<AddStoryController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Container(
            height: 140.h,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: controller.selectedColor.value,
              borderRadius: BorderRadius.circular(20.r),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: controller.textController,
              onChanged: controller.onTextChanged,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Type your status...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Background',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Wrap(
            spacing: 10.w,
            runSpacing: 8.h,
            children: AddStoryController.backgroundColors.map((color) {
              final selected = controller.selectedColor.value == color;
              return GestureDetector(
                onTap: () => controller.selectColor(color),
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? AppColors.navy : AppColors.surface,
                      width: selected ? 2.5 : 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SelectedContactsSection extends GetView<AddStoryController> {
  const _SelectedContactsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose who can view',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: controller.contactSearchController,
            onChanged: controller.onContactQueryChanged,
            style: GoogleFonts.poppins(fontSize: 13.sp, color: AppColors.navy),
            decoration: InputDecoration(
              hintText: 'Search contacts',
              hintStyle: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: AppColors.muted,
              ),
              prefixIcon: Icon(Icons.search_rounded, size: 20.sp),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Text(
              '${controller.selectedContacts.length} selected · min 1 required',
              style: GoogleFonts.poppins(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.muted,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Obx(() {
            final contacts = controller.filteredContacts;
            final _ = controller.selectedContacts.length;
            if (contacts.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  'No contacts found',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: AppColors.muted,
                  ),
                ),
              );
            }

            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 220.h),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: contacts.length,
                separatorBuilder: (_, index) => SizedBox(height: 6.h),
                itemBuilder: (_, index) {
                  final contact = contacts[index];
                  return Obx(
                    () => _StoryContactTile(
                      key: ValueKey(contact.name),
                      contact: contact,
                      selected: controller.selectedContacts
                          .contains(contact.name),
                      onTap: () => controller.toggleContact(contact),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StoryContactTile extends StatelessWidget {
  const _StoryContactTile({
    super.key,
    required this.contact,
    required this.selected,
    required this.onTap,
  });

  final StoryContact contact;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            UserAvatar(name: contact.name, size: 36),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    contact.role,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? AppColors.primary : AppColors.muted,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyChip extends StatelessWidget {
  const _PrivacyChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.white : AppColors.navy,
            ),
          ),
        ),
      ),
    );
  }
}
