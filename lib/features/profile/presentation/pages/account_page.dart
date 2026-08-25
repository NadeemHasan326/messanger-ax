import 'package:messanger_ax/exports.dart';

class AccountPage extends GetView<AccountController> {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const ProfileSettingsHeader(
              title: 'Account',
              subtitle: 'Profile, phone, email',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: controller.pickProfileImage,
                      child: Center(
                        child: Stack(
                          children: [
                            Obx(
                              () => UserAvatar(
                                name: Get.find<ProfileController>().name.value,
                                size: 88,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 28.w,
                                height: 28.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.background,
                                    width: 2.w,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 14.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Tap to change photo',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: AppColors.muted,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Obx(
                      () => AuthTextField(
                        label: 'Name',
                        hint: 'Your name',
                        controller: controller.nameController,
                        textInputAction: TextInputAction.next,
                        errorText: controller.nameError.value,
                        onChanged: controller.clearNameError,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Obx(
                      () => AuthTextField(
                        label: 'Username',
                        hint: 'nadeemhasan',
                        controller: controller.usernameController,
                        textInputAction: TextInputAction.next,
                        errorText: controller.usernameError.value,
                        onChanged: controller.clearUsernameError,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AuthTextField(
                      label: 'About',
                      hint: 'Hey there! I am using Messanger AX.',
                      controller: controller.aboutController,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16.h),
                    Obx(
                      () => AuthTextField(
                        label: 'Email',
                        hint: 'user@example.com',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        errorText: controller.emailError.value,
                        onChanged: controller.clearEmailError,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Obx(
                      () => AuthTextField(
                        label: 'Phone',
                        hint: '1234567890',
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        errorText: controller.phoneError.value,
                        onChanged: controller.clearPhoneError,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0.h),
              child: Obx(
                () => AuthPrimaryButton(
                  label: 'Save changes',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.save,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
