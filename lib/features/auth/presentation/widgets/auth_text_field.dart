import 'package:messanger_ax/exports.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.errorText,
    this.maxLength,
    this.inputFormatters,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  bool get _hasError => errorText != null && errorText!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: AppColors.label,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.softShadow,
                blurRadius: 6.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onChanged: onChanged,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.navy,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.hint,
              ),
              prefixIcon: prefixIcon == null
                  ? null
                  : Padding(
                      padding: EdgeInsets.only(left: 14.w, right: 8.w),
                      child: Icon(
                        prefixIcon,
                        color: AppColors.icon,
                        size: 22.sp,
                      ),
                    ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 15.5.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: _hasError
                    ? BorderSide(color: AppColors.error, width: 1.2.w)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: _hasError ? AppColors.error : AppColors.primary,
                  width: 1.2.w,
                ),
              ),
            ),
          ),
        ),
        if (_hasError) ...[
          SizedBox(height: 6.h),
          Text(
            errorText!,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }
}
