import 'package:intl_phone_field/phone_number.dart';
import 'package:messanger_ax/exports.dart';

class AddContactController extends GetxController {
  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final mobileController = TextEditingController();

  final nameError = RxnString();
  final roleError = RxnString();
  final mobileError = RxnString();
  final isLoading = false.obs;

  PhoneNumber? _phoneNumber;

  void clearNameError(String _) => nameError.value = null;
  void clearRoleError(String _) => roleError.value = null;

  void onPhoneChanged(PhoneNumber phone) {
    _phoneNumber = phone;
    mobileError.value = null;
  }

  bool _validatePhone() {
    final phone = _phoneNumber;
    if (phone == null || phone.number.trim().isEmpty) {
      mobileError.value = 'Mobile number is required';
      return false;
    }

    try {
      phone.isValidNumber();
      mobileError.value = null;
      return true;
    } on Exception {
      mobileError.value = 'Enter a valid mobile number for selected country';
      return false;
    }
  }

  bool _validate() {
    var isValid = true;
    final name = nameController.text.trim();
    final role = roleController.text.trim();

    if (name.isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    } else {
      nameError.value = null;
    }

    if (role.isEmpty) {
      roleError.value = 'Role is required';
      isValid = false;
    } else {
      roleError.value = null;
    }

    if (!_validatePhone()) {
      isValid = false;
    }

    return isValid;
  }

  Future<void> saveContact() async {
    if (!_validate()) return;

    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;

    AppToast.success('${nameController.text.trim()} added to contacts');
    AppNavigation.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    roleController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}
