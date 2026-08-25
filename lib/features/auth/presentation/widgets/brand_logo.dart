import 'package:messanger_ax/exports.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size,
    this.showTitle = true,
  });

  final double? size;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? 32.r;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: AppColors.logoBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.bolt_rounded,
            color: AppColors.primary,
            size: logoSize * 0.68,
          ),
        ),
        if (showTitle) ...[
          SizedBox(width: 10.w),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Messanger ',
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                TextSpan(
                  text: 'AX',
                  style: GoogleFonts.poppins(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
