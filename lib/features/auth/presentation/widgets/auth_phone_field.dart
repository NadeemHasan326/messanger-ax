import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:messanger_ax/exports.dart';

class AuthPhoneField extends StatefulWidget {
  const AuthPhoneField({
    super.key,
    required this.label,
    this.controller,
    this.errorText,
    this.onChanged,
    this.initialCountryCode = 'IN',
    this.textInputAction,
  });

  final String label;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<PhoneNumber>? onChanged;
  final String initialCountryCode;
  final TextInputAction? textInputAction;

  @override
  State<AuthPhoneField> createState() => _AuthPhoneFieldState();
}

class _AuthPhoneFieldState extends State<AuthPhoneField> {
  late Country _selectedCountry;
  late TextEditingController _controller;
  late bool _ownsController;

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _selectedCountry = countries.firstWhere(
      (c) => c.code == widget.initialCountryCode,
      orElse: () => countries.firstWhere((c) => c.code == 'IN'),
    );
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_notifyChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_notifyChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  PhoneNumber get _phoneNumber => PhoneNumber(
        countryISOCode: _selectedCountry.code,
        countryCode: '+${_selectedCountry.fullCountryCode}',
        number: _controller.text,
      );

  void _notifyChanged() {
    widget.onChanged?.call(_phoneNumber);
  }

  Future<void> _openCountryPicker() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final picked = await CountryPickerBottomSheet.show(
      context,
      selectedCountry: _selectedCountry,
    );
    if (picked == null || !mounted) return;

    setState(() {
      _selectedCountry = picked;
      final text = _controller.text;
      if (text.length > picked.maxLength) {
        _controller.text = text.substring(0, picked.maxLength);
        _controller.selection = TextSelection.collapsed(
          offset: _controller.text.length,
        );
      }
    });
    _notifyChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
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
            controller: _controller,
            keyboardType: TextInputType.phone,
            textInputAction: widget.textInputAction,
            maxLength: _selectedCountry.maxLength,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.navy,
            ),
            decoration: InputDecoration(
              hintText: 'Mobile number',
              counterText: '',
              hintStyle: GoogleFonts.poppins(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.hint,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: EdgeInsets.symmetric(vertical: 15.5.h),
              prefixIcon: GestureDetector(
                onTap: _openCountryPicker,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(left: 12.w, right: 4.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedCountry.flag,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '+${_selectedCountry.displayCC}',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.icon,
                        size: 22.sp,
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 1,
                        height: 24.h,
                        color: AppColors.divider,
                      ),
                      SizedBox(width: 4.w),
                    ],
                  ),
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
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
            widget.errorText!,
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
