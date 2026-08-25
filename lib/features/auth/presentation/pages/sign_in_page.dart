import 'package:messanger_ax/exports.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SlideFadeIn(
                  delay: const Duration(milliseconds: 120),
                  child: const BrandLogo(),
                ),
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: AppColors.background,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideFadeIn(
                      delay: const Duration(milliseconds: 240),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 45.w,
                            height: 45.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryGlow,
                                  blurRadius: 14.r,
                                  offset: Offset(0, 6.h),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              color: AppColors.white,
                              size: 30.sp,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sign In',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.navy,
                                    height: 1.15,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Welcome back to the platform',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    SlideFadeIn(
                      delay: const Duration(milliseconds: 360),
                      child: Obx(
                        () => AuthTextField(
                          label: 'Email or Mobile',
                          hint: 'user@example.com or mobile',
                          controller: controller.emailOrMobileController,
                          prefixIcon: Icons.person_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          errorText: controller.emailOrMobileError.value,
                          onChanged: controller.onEmailOrMobileChanged,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SlideFadeIn(
                      delay: const Duration(milliseconds: 480),
                      child: Obx(
                        () => AuthTextField(
                          label: 'Password',
                          hint: 'Enter your password',
                          controller: controller.passwordController,
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: !controller.isPasswordVisible.value,
                          textInputAction: TextInputAction.done,
                          errorText: controller.passwordError.value,
                          onChanged: controller.onPasswordChanged,
                          suffixIcon: IconButton(
                            onPressed: controller.togglePasswordVisibility,
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.icon,
                              size: 22.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SlideFadeIn(
                      delay: const Duration(milliseconds: 600),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: controller.goToForgotPassword,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    SlideFadeIn(
                      delay: const Duration(milliseconds: 720),
                      child: Obx(
                        () => AuthPrimaryButton(
                          label: 'Sign In',
                          isLoading: controller.isLoading.value,
                          onPressed: controller.signIn,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    SlideFadeIn(
                      delay: const Duration(milliseconds: 840),
                      child: Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.muted,
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.goToCreateAccount,
                              child: Text(
                                'Create Account',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
