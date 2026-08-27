import 'package:messanger_ax/exports.dart';

class CreateChannelPage extends GetView<CreateChannelController> {
  const CreateChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CreateChannelHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 16.h),
                children: [
                  Obx(
                    () => DisplayPicturePicker(
                      bytes: controller.avatarBytes.value,
                      placeholderIcon: Icons.campaign_rounded,
                      onTap: controller.pickAvatar,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Obx(
                    () => AuthTextField(
                      label: 'Channel name',
                      hint: 'Product updates',
                      controller: controller.nameController,
                      textInputAction: TextInputAction.next,
                      errorText: controller.nameError.value,
                      maxLength: 40,
                      onChanged: controller.onNameChanged,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  AuthTextField(
                    label: 'Description',
                    hint: 'What this channel is about',
                    controller: controller.descriptionController,
                    textInputAction: TextInputAction.done,
                    maxLength: 120,
                    onChanged: controller.onDescriptionChanged,
                  ),
                  SizedBox(height: 18.h),
                  Container(
                    padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.campaign_rounded,
                          color: AppColors.primary,
                          size: 22.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            'Anyone can find and follow this channel. Only you can post updates.',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5.sp,
                              height: 1.45,
                              color: AppColors.label,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              child: Obx(
                () => AuthPrimaryButton(
                  label: 'Create channel',
                  isLoading: controller.isLoading.value,
                  onPressed:
                      controller.canCreate ? controller.createChannel : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateChannelHeader extends StatelessWidget {
  const _CreateChannelHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 20.w, 12.h),
      child: Row(
        children: [
          const AppBackButton(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Channel',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    height: 1.15,
                  ),
                ),
                Text(
                  'Create a broadcast your followers can read',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
