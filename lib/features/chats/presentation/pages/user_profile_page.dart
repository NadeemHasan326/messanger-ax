import 'package:messanger_ax/exports.dart';

class UserProfilePage extends GetView<UserProfileController> {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = controller.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 8.h),
              child: Row(
                children: [
                  const AppBackButton(),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      profile.username,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  _HeaderIconButton(
                    icon: Icons.more_horiz_rounded,
                    onTap: () => _UserProfileMoreSheet.show(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                children: [
                  Row(
                    children: [
                      UserAvatar(
                        name: profile.name,
                        size: 86,
                        showOnline: profile.online,
                        onlineIndicatorSize: 14,
                      ),
                      SizedBox(width: 22.w),
                      Expanded(
                        child: Row(
                          children: [
                            _StatBlock(value: profile.posts, label: 'Posts'),
                            _StatBlock(
                              value: profile.followers,
                              label: 'Followers',
                            ),
                            _StatBlock(
                              value: profile.following,
                              label: 'Following',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    profile.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    profile.role,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: AppColors.muted,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    profile.bio,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      height: 1.4,
                      color: AppColors.label,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final following = controller.isFollowing.value;
                          return GestureDetector(
                            onTap: controller.toggleFollow,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              height: 42.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: following
                                    ? AppColors.white
                                    : AppColors.primary,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: following
                                      ? AppColors.divider
                                      : AppColors.primary,
                                ),
                              ),
                              child: Text(
                                following ? 'Following' : 'Follow',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: following
                                      ? AppColors.navy
                                      : AppColors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: controller.messageUser,
                          child: Container(
                            height: 42.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Text(
                              'Message',
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  Row(
                    children: [
                      Icon(
                        Icons.grid_on_rounded,
                        size: 18.sp,
                        color: AppColors.navy,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Posts',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: profile.postColors.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.w,
                      mainAxisSpacing: 4.h,
                    ),
                    itemBuilder: (_, index) {
                      final colors = profile.postColors[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: colors,
                            ),
                          ),
                        ),
                      );
                    },
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

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.black.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.softShadow,
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.navy, size: 22.sp),
      ),
    );
  }
}

class _UserProfileMoreSheet extends StatelessWidget {
  const _UserProfileMoreSheet();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _UserProfileMoreSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserProfileController>();
    final name = controller.profile.name;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 16.h),
              _MoreTile(
                icon: Icons.share_outlined,
                label: 'Share profile',
                onTap: () => controller.onMoreAction('Shared $name\'s profile'),
              ),
              _MoreTile(
                icon: Icons.link_rounded,
                label: 'Copy username',
                onTap: () => controller.onMoreAction(
                  'Copied @${controller.profile.username}',
                ),
              ),
              _MoreTile(
                icon: Icons.notifications_off_outlined,
                label: 'Mute',
                onTap: () => controller.onMoreAction('Muted $name'),
              ),
              _MoreTile(
                icon: Icons.block_rounded,
                label: 'Block',
                destructive: true,
                onTap: () => controller.onMoreAction('Blocked $name'),
              ),
              _MoreTile(
                icon: Icons.flag_outlined,
                label: 'Report',
                destructive: true,
                onTap: () => controller.onMoreAction('Reported $name'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.error : AppColors.navy;
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      leading: Icon(icon, color: color, size: 22.sp),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
