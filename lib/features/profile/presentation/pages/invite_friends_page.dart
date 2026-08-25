import 'package:messanger_ax/exports.dart';

class InviteFriendsPage extends GetView<InviteFriendsController> {
  const InviteFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const ProfileSettingsHeader(
              title: 'Invite Friends',
              subtitle: 'Share Messanger AX',
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
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
                        Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: BoxDecoration(
                            color: AppColors.logoBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.card_giftcard_rounded,
                            color: AppColors.primary,
                            size: 26.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Your invite code',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: AppColors.muted,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          controller.inviteCode,
                          style: GoogleFonts.poppins(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: AppColors.navy,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          controller.inviteLink,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: _ShareAction(
                          icon: Icons.link_rounded,
                          label: 'Copy link',
                          onTap: controller.copyLink,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _ShareAction(
                          icon: Icons.tag_rounded,
                          label: 'Copy code',
                          onTap: controller.copyCode,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _ShareAction(
                          icon: Icons.chat_outlined,
                          label: 'Copy text',
                          onTap: controller.copyMessage,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  Text(
                    'SUGGESTED CONTACTS',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.7,
                      color: AppColors.muted,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SettingsGroupCard(
                    children: [
                      for (final contact in controller.suggested)
                        Obx(() {
                          final invited = controller.isInvited(contact.name);
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            child: Row(
                              children: [
                                UserAvatar(name: contact.name, size: 42),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contact.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                      Text(
                                        contact.role,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11.5.sp,
                                          color: AppColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: invited
                                      ? null
                                      : () => controller.inviteContact(contact),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: invited
                                          ? AppColors.chipBg
                                          : AppColors.primary,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      invited ? 'Invited' : 'Invite',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: invited
                                            ? AppColors.muted
                                            : AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareAction extends StatelessWidget {
  const _ShareAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
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
            Icon(icon, color: AppColors.primary, size: 22.sp),
            SizedBox(height: 6.h),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
