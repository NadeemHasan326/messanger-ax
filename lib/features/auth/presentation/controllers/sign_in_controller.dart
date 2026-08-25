import 'package:messanger_ax/exports.dart';

class SignInController extends GetxController {
  final emailOrMobileController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final emailOrMobileError = RxnString();
  final passwordError = RxnString();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void onEmailOrMobileChanged(String _) => emailOrMobileError.value = null;

  void onPasswordChanged(String _) => passwordError.value = null;

  bool _validate() {
    var isValid = true;
    final emailOrMobile = emailOrMobileController.text.trim();
    final password = passwordController.text;

    if (emailOrMobile.isEmpty) {
      emailOrMobileError.value = 'Email or mobile is required';
      isValid = false;
    } else {
      emailOrMobileError.value = null;
    }

    if (password.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else {
      passwordError.value = null;
    }

    return isValid;
  }

  Future<void> signIn() async {
    if (!_validate()) return;

    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
    AppNavigation.resetTo(AppRoutes.home);
  }

  void goToForgotPassword() => AppNavigation.push(AppRoutes.forgotPassword);

  void goToCreateAccount() => AppNavigation.push(AppRoutes.createAccount);

  @override
  void onClose() {
    emailOrMobileController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
