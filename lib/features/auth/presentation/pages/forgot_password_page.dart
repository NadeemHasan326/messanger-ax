import 'package:messanger_ax/exports.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AuthAppBar(title: 'Forgot Password'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SlideFadeIn(
                delay: const Duration(milliseconds: 160),
                child: Text(
                  'Enter your registered mobile number. We will send a 4-digit code to reset your password.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.55,
                    color: AppColors.muted,
                  ),
                ),
              ),
              SizedBox(height: 36.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 360),
                child: Obx(
                  () => AuthTextField(
                    label: 'Mobile Number',
                    hint: '1234567890',
                    controller: controller.mobileController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    errorText: controller.mobileError.value,
                    onChanged: controller.onMobileChanged,
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              SlideFadeIn(
                delay: const Duration(milliseconds: 560),
                child: Obx(
                  () => AuthPrimaryButton(
                    label: 'Send OTP',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.sendOtp,
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
