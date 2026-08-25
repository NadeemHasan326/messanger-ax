import 'package:intl_phone_field/countries.dart';
import 'package:messanger_ax/exports.dart';

class CountryPickerBottomSheet extends StatefulWidget {
  const CountryPickerBottomSheet({
    super.key,
    required this.selectedCountry,
    this.countriesList = countries,
  });

  final Country selectedCountry;
  final List<Country> countriesList;

  static Future<Country?> show(
    BuildContext context, {
    required Country selectedCountry,
    List<Country>? countriesList,
  }) {
    return showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CountryPickerBottomSheet(
        selectedCountry: selectedCountry,
        countriesList: countriesList ?? countries,
      ),
    );
  }

  @override
  State<CountryPickerBottomSheet> createState() =>
      _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  late List<Country> _filtered;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = List<Country>.from(widget.countriesList)
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = List<Country>.from(widget.countriesList)
          ..sort((a, b) => a.name.compareTo(b.name));
        return;
      }
      _filtered = widget.countriesList
          .where(
            (country) =>
                country.name.toLowerCase().contains(q) ||
                country.dialCode.contains(q) ||
                country.code.toLowerCase().contains(q),
          )
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Country',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: AppColors.chipBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18.sp,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.navy,
                ),
                decoration: InputDecoration(
                  hintText: 'Search country',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: AppColors.hint,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.icon,
                    size: 22.sp,
                  ),
                  filled: true,
                  fillColor: AppColors.chipBg,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.2.w,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
                itemCount: _filtered.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: AppColors.divider,
                ),
                itemBuilder: (context, index) {
                  final country = _filtered[index];
                  final isSelected = country.code == widget.selectedCountry.code;
                  return InkWell(
                    onTap: () => Navigator.pop(context, country),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        children: [
                          Text(
                            country.flag,
                            style: TextStyle(fontSize: 22.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              country.name,
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                          Text(
                            '+${country.displayCC}',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          if (isSelected) ...[
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.check_circle_rounded,
                              size: 20.sp,
                              color: AppColors.primary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
