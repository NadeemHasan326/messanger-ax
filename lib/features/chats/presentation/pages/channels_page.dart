import 'package:messanger_ax/exports.dart';

class ChannelsPage extends GetView<ChannelsController> {
  const ChannelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 20.w, 8.h),
              child: Row(
                children: [
                  const AppBackButton(),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Channels',
                          style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            height: 1.15,
                          ),
                        ),
                        Text(
                          'Create a channel or follow one',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.openCreate,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.black.withValues(alpha: 0.15),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.add_rounded,
                        color: AppColors.navy,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            LandingSearchBar(
              hint: 'Search channels',
              showFilter: false,
              controller: controller.searchController,
              onChanged: controller.onQueryChanged,
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: Obx(() {
                final channels = controller.visibleChannels;
                if (channels.isEmpty) {
                  return Center(
                    child: Text(
                      'No channels match that search',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: AppColors.muted,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
                  itemCount: channels.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: AppColors.divider,
                  ),
                  itemBuilder: (_, index) {
                    final channel = channels[index];
                    return _ChannelTile(channel: channel);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChannelTile extends StatelessWidget {
  const _ChannelTile({required this.channel});

  final ChatChannel channel;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChannelsController>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => controller.openChannel(channel),
            child: UserAvatar(name: channel.name, size: 48),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.openChannel(channel),
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          channel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.campaign_rounded,
                        size: 14.sp,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    channel.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.muted,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    channel.followersLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          _FollowButton(
            joined: channel.isJoined,
            isAdmin: channel.isAdmin,
            onTap: () => controller.toggleFollow(channel),
          ),
        ],
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({
    required this.joined,
    required this.isAdmin,
    required this.onTap,
  });

  final bool joined;
  final bool isAdmin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = isAdmin
        ? 'Yours'
        : joined
            ? 'Following'
            : 'Follow';
    return GestureDetector(
      onTap: isAdmin ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: joined ? AppColors.surface : AppColors.primary,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: joined ? AppColors.divider : AppColors.primary,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: joined ? AppColors.navy : AppColors.white,
          ),
        ),
      ),
    );
  }
}
