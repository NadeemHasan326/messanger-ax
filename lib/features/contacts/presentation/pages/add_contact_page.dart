import 'package:messanger_ax/exports.dart';

class AddContactPage extends GetView<AddContactController> {
  const AddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AuthAppBar(title: 'New Contact'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add someone to your contacts and start chatting instantly.',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.55,
                  color: AppColors.muted,
                ),
              ),
              SizedBox(height: 28.h),
              Obx(
                () => AuthTextField(
                  label: 'Name',
                  hint: 'John Doe',
                  controller: controller.nameController,
                  textInputAction: TextInputAction.next,
                  errorText: controller.nameError.value,
                  onChanged: controller.clearNameError,
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => AuthTextField(
                  label: 'Role',
                  hint: 'Product Designer',
                  controller: controller.roleController,
                  textInputAction: TextInputAction.next,
                  errorText: controller.roleError.value,
                  onChanged: controller.clearRoleError,
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => AuthPhoneField(
                  label: 'Mobile Number',
                  controller: controller.mobileController,
                  textInputAction: TextInputAction.done,
                  errorText: controller.mobileError.value,
                  onChanged: controller.onPhoneChanged,
                ),
              ),
              SizedBox(height: 32.h),
              Obx(
                () => AuthPrimaryButton(
                  label: 'Save Contact',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.saveContact,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
