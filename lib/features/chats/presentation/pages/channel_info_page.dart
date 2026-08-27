import 'package:messanger_ax/exports.dart';

class ChannelInfoPage extends GetView<ChannelInfoController> {
  const ChannelInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const ProfileSettingsHeader(title: 'Channel info'),
          Expanded(
            child: Obx(() {
              final joined = controller.isJoined;
              final admin = controller.isAdmin;
              final muted = controller.isMuted;
              final posts = controller.recentPosts;
              final description = controller.description;
              return ListView(
                padding: EdgeInsets.only(bottom: 28.h),
                children: [
                  _ChannelProfileSection(
                    name: controller.channelName,
                    handle: controller.handle,
                    followersLabel: controller.followersLabel,
                    description: description,
                    roleLabel: controller.roleLabel,
                    followersValue: controller.followersValue,
                    postCount: controller.postCount,
                    createdLabel: controller.createdLabel,
                    showFollow: !admin,
                    joined: joined,
                    onFollow: controller.toggleFollow,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                    child: Column(
                      children: [
                        SettingsGroupCard(
                          title: 'About',
                          children: [
                            SettingsListTile(
                              title: 'Handle',
                              trailingText: controller.handle,
                              leadingIcon: Icons.alternate_email_rounded,
                            ),
                            SettingsListTile(
                              title: 'Visibility',
                              subtitle:
                                  'Anyone can find and follow this channel',
                              trailingText: 'Public',
                              leadingIcon: Icons.public_rounded,
                            ),
                            SettingsListTile(
                              title: 'Who can post',
                              subtitle: admin
                                  ? 'You can publish updates'
                                  : 'Only admins can post',
                              trailingText: 'Admins',
                              leadingIcon: Icons.edit_note_rounded,
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        SettingsGroupCard(
                          title: 'Notifications',
                          children: [
                            SettingsListTile(
                              title: 'Mute',
                              subtitle: 'Stop alerts for new posts',
                              leadingIcon: Icons.notifications_off_outlined,
                              switchValue: muted,
                              onSwitchChanged: (_) => controller.toggleMute(),
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        SettingsGroupCard(
                          title: 'Channel',
                          children: [
                            SettingsListTile(
                              title: 'Wallpaper',
                              subtitle: 'Change the chat background',
                              leadingIcon: Icons.wallpaper_rounded,
                              onTap: controller.pickWallpaper,
                            ),
                            SettingsListTile(
                              title: 'Share channel',
                              subtitle: 'Send an invite to friends',
                              leadingIcon: Icons.share_outlined,
                              onTap: controller.shareChannel,
                            ),
                            SettingsListTile(
                              title: 'Copy invite link',
                              subtitle: controller.inviteLink,
                              leadingIcon: Icons.link_rounded,
                              onTap: controller.copyInviteLink,
                            ),
                          ],
                        ),
                        if (admin) ...[
                          SizedBox(height: 18.h),
                          SettingsGroupCard(
                            title: 'Manage',
                            children: [
                              SettingsListTile(
                                title: 'Edit description',
                                subtitle: description.isEmpty
                                    ? 'Add a short description'
                                    : description,
                                leadingIcon: Icons.notes_rounded,
                                onTap: () => _EditDescriptionSheet.show(context),
                              ),
                              SettingsListTile(
                                title: 'Delete channel',
                                subtitle: 'Remove the channel you created',
                                leadingIcon: Icons.delete_outline_rounded,
                                destructive: true,
                                onTap: controller.confirmDelete,
                              ),
                            ],
                          ),
                        ],
                        if (posts.isNotEmpty) ...[
                          SizedBox(height: 18.h),
                          SettingsGroupCard(
                            title: 'Recent posts',
                            children: [
                              for (final post in posts)
                                SettingsListTile(
                                  title: post.text.length > 72
                                      ? '${post.text.substring(0, 72)}…'
                                      : post.text,
                                  subtitle: post.time,
                                  leadingIcon: Icons.campaign_outlined,
                                ),
                            ],
                          ),
                        ],
                        if (joined && !admin) ...[
                          SizedBox(height: 18.h),
                          SettingsGroupCard(
                            children: [
                              SettingsListTile(
                                title: 'Unfollow',
                                subtitle: 'Remove this channel from Chats',
                                leadingIcon:
                                    Icons.person_remove_alt_1_rounded,
                                destructive: true,
                                onTap: controller.confirmUnfollow,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ChannelProfileSection extends StatelessWidget {
  const _ChannelProfileSection({
    required this.name,
    required this.handle,
    required this.followersLabel,
    required this.description,
    required this.roleLabel,
    required this.followersValue,
    required this.postCount,
    required this.createdLabel,
    required this.showFollow,
    required this.joined,
    required this.onFollow,
  });

  final String name;
  final String handle;
  final String followersLabel;
  final String description;
  final String roleLabel;
  final String followersValue;
  final String postCount;
  final String createdLabel;
  final bool showFollow;
  final bool joined;
  final VoidCallback onFollow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.softShadow,
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 22.h),
        child: Column(
          children: [
            UserAvatar(name: name, size: 96),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.campaign_rounded,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              handle,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.muted,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                roleLabel,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            if (description.isNotEmpty) ...[
              SizedBox(height: 14.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: AppColors.navy,
                ),
              ),
            ],
            SizedBox(height: 6.h),
            Text(
              followersLabel,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: AppColors.muted,
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                _StatBlock(value: followersValue, label: 'Followers'),
                const _StatDivider(),
                _StatBlock(value: postCount, label: 'Posts'),
                const _StatDivider(),
                _StatBlock(value: createdLabel, label: 'Created'),
              ],
            ),
            if (showFollow) ...[
              SizedBox(height: 18.h),
              _FollowButton(joined: joined, onTap: onFollow),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28.h,
      color: AppColors.divider,
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({required this.joined, required this.onTap});

  final bool joined;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 46.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: joined ? AppColors.surface : AppColors.primary,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: joined ? AppColors.divider : AppColors.primary,
          ),
        ),
        child: Text(
          joined ? 'Following' : 'Follow',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: joined ? AppColors.navy : AppColors.white,
          ),
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
              height: 1.2,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditDescriptionSheet extends StatelessWidget {
  const _EditDescriptionSheet();

  static Future<void> show(BuildContext context) {
    final controller = Get.find<ChannelInfoController>();
    controller.beginEditDescription();
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _EditDescriptionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChannelInfoController>();
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Edit description',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                AuthTextField(
                  label: 'Description',
                  hint: 'What this channel is about',
                  controller: controller.descriptionController,
                  textInputAction: TextInputAction.done,
                  maxLength: 120,
                ),
                SizedBox(height: 16.h),
                AuthPrimaryButton(
                  label: 'Save',
                  onPressed: controller.saveDescription,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
