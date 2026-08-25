import 'package:messanger_ax/exports.dart';

class AccountController extends GetxController {
  late final TextEditingController nameController;
  late final TextEditingController usernameController;
  late final TextEditingController aboutController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  final isLoading = false.obs;
  final nameError = RxnString();
  final usernameError = RxnString();
  final emailError = RxnString();
  final phoneError = RxnString();

  ProfileController get _profile => Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: _profile.name.value);
    usernameController = TextEditingController(text: _profile.username.value);
    aboutController = TextEditingController(text: _profile.about.value);
    emailController = TextEditingController(text: _profile.email.value);
    phoneController = TextEditingController(text: _profile.phone.value);
  }

  void clearNameError(String _) => nameError.value = null;
  void clearUsernameError(String _) => usernameError.value = null;
  void clearEmailError(String _) => emailError.value = null;
  void clearPhoneError(String _) => phoneError.value = null;

  void pickProfileImage() {
    AppToast.info('Image picker will be connected here.');
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  bool _validate() {
    var isValid = true;
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    } else {
      nameError.value = null;
    }

    if (username.isEmpty) {
      usernameError.value = 'Username is required';
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z0-9._]{3,20}$').hasMatch(username)) {
      usernameError.value = 'Use 3–20 letters, numbers, dots or underscores';
      isValid = false;
    } else {
      usernameError.value = null;
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

    if (phone.isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    } else if (phone.length != 10 || int.tryParse(phone) == null) {
      phoneError.value = 'Phone number must be 10 digits';
      isValid = false;
    } else {
      phoneError.value = null;
    }

    return isValid;
  }

  Future<void> save() async {
    if (!_validate()) return;

    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 500));

    _profile.name.value = nameController.text.trim();
    _profile.username.value = usernameController.text.trim();
    _profile.about.value = aboutController.text.trim().isEmpty
        ? 'Hey there! I am using Messanger AX.'
        : aboutController.text.trim();
    _profile.email.value = emailController.text.trim();
    _profile.phone.value = phoneController.text.trim();

    isLoading.value = false;
    AppToast.success('Account updated');
    AppNavigation.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    aboutController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
