import 'package:messanger_ax/exports.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      leadingWidth: 72.w,
      titleSpacing: 12.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: AppBackButton(size: 40),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
