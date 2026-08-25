import 'package:messanger_ax/exports.dart';

class SettingsGroupCard extends StatelessWidget {
  const SettingsGroupCard({
    super.key,
    required this.children,
    this.title,
  });

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 8.h),
            child: Text(
              title!.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
                color: AppColors.muted,
              ),
            ),
          ),
        ],
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Divider(height: 1, color: AppColors.divider),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
