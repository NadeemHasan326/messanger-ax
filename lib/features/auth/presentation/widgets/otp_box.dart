import 'package:messanger_ax/exports.dart';

class OtpBox extends StatelessWidget {
  const OtpBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.hasError = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, child) {
        final isFocused = focusNode.hasFocus;
        final borderColor = hasError
            ? AppColors.error
            : isFocused
                ? AppColors.primary
                : AppColors.checkboxBorder;

        return Container(
          width: 58.w,
          height: 55.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: borderColor,
              width: isFocused || hasError ? 1.4.w : 1.w,
            ),
          ),
          child: child,
        );
      },
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLength: 1,
        cursorColor: AppColors.primary,
        style: GoogleFonts.poppins(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
          height: 1,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isCollapsed: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
