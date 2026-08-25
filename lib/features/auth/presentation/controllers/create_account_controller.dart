import 'package:messanger_ax/exports.dart';

class CreateAccountController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final agreedToTerms = false.obs;
  final isLoading = false.obs;

  final nameError = RxnString();
  final emailError = RxnString();
  final mobileError = RxnString();
  final passwordError = RxnString();
  final confirmPasswordError = RxnString();
  final termsError = RxnString();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleTerms(bool? value) {
    agreedToTerms.value = value ?? false;
    if (agreedToTerms.value) termsError.value = null;
  }

  void clearNameError(String _) => nameError.value = null;
  void clearEmailError(String _) => emailError.value = null;
  void clearMobileError(String _) => mobileError.value = null;
  void clearPasswordError(String _) => passwordError.value = null;
  void clearConfirmPasswordError(String _) => confirmPasswordError.value = null;

  void pickProfileImage() {
    AppToast.info('Image picker will be connected here.');
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  bool _validate() {
    var isValid = true;
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final mobile = mobileController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    } else {
      nameError.value = null;
    }

    if (email.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!_isValidEmail(email)) {
      emailError.value = 'Enter a valid email address';
      isValid = false;
    } else {
      emailError.value = null;
    }

    if (mobile.isEmpty) {
      mobileError.value = 'Mobile number is required';
      isValid = false;
    } else if (mobile.length != 10 || int.tryParse(mobile) == null) {
      mobileError.value = 'Mobile number must be 10 digits';
      isValid = false;
    } else {
      mobileError.value = null;
    }

    if (password.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    } else {
      passwordError.value = null;
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
      isValid = false;
    } else if (confirmPassword != password) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    } else {
      confirmPasswordError.value = null;
    }

    if (!agreedToTerms.value) {
      termsError.value = 'Please agree to the Terms of Service and Privacy Policy';
      isValid = false;
    } else {
      termsError.value = null;
    }

    return isValid;
  }

  Future<void> register() async {
    if (!_validate()) return;

    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
    AppNavigation.push(
      AppRoutes.verifyEmail,
      arguments: {'email': emailController.text.trim()},
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
