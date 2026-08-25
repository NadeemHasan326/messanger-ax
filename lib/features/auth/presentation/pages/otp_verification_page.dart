import 'package:messanger_ax/exports.dart';

class OtpVerificationPage extends GetView<OtpVerificationController> {
  const OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AuthAppBar(title: 'Verify Email'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 28.h),
          child: Column(
            children: [
              SlideFadeIn(
                delay:  Duration(milliseconds: 120),
                child: Container(
                  width: 88.w,
                  height: 88.w,
                  decoration:  BoxDecoration(
                    color: AppColors.logoBg.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.mail_outline_rounded,
                        size: 40.sp,
                        color: AppColors.primary,
                      ),
                      Positioned(
                        right: 24.w,
                        top: 24.h,
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 240),
                child: Text(
                  'Check Your Email',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.navy,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 360),
                child: Text.rich(
                  TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.muted,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'We have sent a 4-digit verification code to\n',
                      ),
                      TextSpan(
                        text: controller.email.isEmpty
                            ? 'your email'
                            : controller.email,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 480),
                child: Obx(
                  () => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          OtpVerificationController.otpLength,
                          (index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: OtpBox(
                                controller: controller.otpControllers[index],
                                focusNode: controller.focusNodes[index],
                                hasError: controller.otpError.value != null,
                                onChanged: (value) =>
                                    controller.onOtpChanged(value, index),
                              ),
                            );
                          },
                        ),
                      ),
                      if (controller.otpError.value != null) ...[
                        SizedBox(height: 10.h),
                        Text(
                          controller.otpError.value!,
                          textAlign: TextAlign.center,
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
              SizedBox(height: 34.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 600),
                child: Obx(
                  () => AuthPrimaryButton(
                    label: 'Verify & Continue',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.verifyAndContinue,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 720),
                child: Obx(
                  () => Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.muted,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.isResending.value
                            ? null
                            : controller.resendCode,
                        child: Text(
                          controller.isResending.value ? 'Sending...' : 'Resend',
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
            ],
          ),
        ),
      ),
    );
  }
}
