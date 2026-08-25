import 'package:messanger_ax/exports.dart';

class ForgotPasswordController extends GetxController {
  final mobileController = TextEditingController();
  final isLoading = false.obs;
  final mobileError = RxnString();

  void onMobileChanged(String _) => mobileError.value = null;

  bool _validate() {
    final mobile = mobileController.text.trim();
    if (mobile.isEmpty) {
      mobileError.value = 'Mobile number is required';
      return false;
    }
    if (mobile.length != 10 || int.tryParse(mobile) == null) {
      mobileError.value = 'Mobile number must be 10 digits';
      return false;
    }
    mobileError.value = null;
    return true;
  }

  Future<void> sendOtp() async {
    if (!_validate()) return;

    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
    AppToast.success(
      'A 4-digit code has been sent to your mobile number.',
    );
  }

  @override
  void onClose() {
    mobileController.dispose();
    super.onClose();
  }
}
