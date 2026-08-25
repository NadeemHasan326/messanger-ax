import 'package:messanger_ax/exports.dart';

class CreateAccountPage extends GetView<CreateAccountController> {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AuthAppBar(title: 'Create Account'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SlideFadeIn(
                delay: const Duration(milliseconds: 120),
                child: ProfileAvatarPicker(onTap: controller.pickProfileImage),
              ),
              SizedBox(height: 28.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 240),
                child: Obx(
                  () => AuthTextField(
                    label: 'Name',
                    hint: 'John Doe',
                    controller: controller.nameController,
                    textInputAction: TextInputAction.next,
                    errorText: controller.nameError.value,
                    onChanged: controller.clearNameError,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 360),
                child: Obx(
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
              ),
              SizedBox(height: 16.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 480),
                child: Obx(
                  () => AuthTextField(
                    label: 'Mobile Number',
                    hint: '1234567890',
                    controller: controller.mobileController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    errorText: controller.mobileError.value,
                    onChanged: controller.clearMobileError,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 600),
                child: Obx(
                  () => AuthTextField(
                    label: 'Password',
                    hint: 'Password',
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    textInputAction: TextInputAction.next,
                    errorText: controller.passwordError.value,
                    onChanged: controller.clearPasswordError,
                    suffixIcon: IconButton(
                      onPressed: controller.togglePasswordVisibility,
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.icon,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 720),
                child: Obx(
                  () => AuthTextField(
                    label: 'Confirm Password',
                    hint: 'Confirm Password',
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    textInputAction: TextInputAction.done,
                    errorText: controller.confirmPasswordError.value,
                    onChanged: controller.clearConfirmPasswordError,
                    suffixIcon: IconButton(
                      onPressed: controller.toggleConfirmPasswordVisibility,
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.icon,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 840),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Checkbox(
                              value: controller.agreedToTerms.value,
                              onChanged: controller.toggleTerms,
                              side: BorderSide(
                                color: controller.termsError.value != null
                                    ? AppColors.error
                                    : AppColors.checkboxBorder,
                                width: 1.5.w,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text.rich(
                                TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.muted,
                                    height: 1.45,
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (controller.termsError.value != null) ...[
                        SizedBox(height: 6.h),
                        Text(
                          controller.termsError.value!,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 960),
                child: Obx(
                  () => AuthPrimaryButton(
                    label: 'Register',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.register,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
