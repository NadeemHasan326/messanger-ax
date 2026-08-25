import 'package:messanger_ax/exports.dart';

class OtpVerificationController extends GetxController {
  static const int otpLength = 4;

  late final String email;
  final otpControllers = List.generate(otpLength, (_) => TextEditingController());
  final focusNodes = List.generate(otpLength, (_) => FocusNode());

  final isLoading = false.obs;
  final isResending = false.obs;
  final otpError = RxnString();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['email'] is String) {
      email = args['email'] as String;
    } else if (args is String) {
      email = args;
    } else {
      email = '';
    }
  }

  String get otpCode => otpControllers.map((c) => c.text).join();

  void onOtpChanged(String value, int index) {
    otpError.value = null;
    if (value.length == 1 && index < otpLength - 1) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  bool _validate() {
    if (otpCode.length != otpLength) {
      otpError.value = 'Please enter the 4-digit verification code';
      return false;
    }
    otpError.value = null;
    return true;
  }

  Future<void> verifyAndContinue() async {
    if (!_validate()) return;

    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
    AppNavigation.resetTo(AppRoutes.signIn);
    AppToast.success('Email verified successfully. Please sign in.');
  }

  Future<void> resendCode() async {
    isResending.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    isResending.value = false;
    AppToast.success('A new verification code was sent to $email');
  }

  @override
  void onClose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
