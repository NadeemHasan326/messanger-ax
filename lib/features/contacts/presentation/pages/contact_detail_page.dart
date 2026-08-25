import 'package:messanger_ax/exports.dart';

class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final contact = args is ContactItem
        ? args
        : const ContactItem(
            name: 'Nina Williams',
            role: 'Product Designer',
            section: 'N',
          );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                child: Row(
                  children: [
                    const AppBackButton(),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_horiz, color: AppColors.navy),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      AppColors.background,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    UserAvatar(name: contact.name, size: 96, showOnline: true),
                    SizedBox(height: 14.h),
                    Text(
                      contact.name,
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Online · ${contact.role}',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: AppColors.muted,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionCard(
                          icon: Icons.chat_bubble_rounded,
                          label: 'Message',
                          onTap: () => ChatNavigation.open(
                            name: contact.name,
                            online: true,
                          ),
                        ),
                        const _ActionCard(icon: Icons.call_rounded, label: 'Call'),
                        const _ActionCard(icon: Icons.videocam_rounded, label: 'Video'),
                        const _ActionCard(icon: Icons.more_horiz_rounded, label: 'More'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Designing thoughtful product experiences and keeping teams aligned across launches.',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        height: 1.5,
                        color: AppColors.muted,
                      ),
                    ),
                    SizedBox(height: 22.h),
                    Row(
                      children: [
                        Text(
                          'Media, Links & Docs',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'View all',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      height: 72.w,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        separatorBuilder: (_, _) => SizedBox(width: 10.w),
                        itemBuilder: (context, index) {
                          return Container(
                            width: 72.w,
                            height: 72.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.avatarBg,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: index == 4
                                ? Text(
                                    '+12',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : Icon(
                                    Icons.image_outlined,
                                    color: AppColors.primary,
                                    size: 26.sp,
                                  ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 22.h),
                    Text(
                      'Groups in common',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const _GroupTile(name: 'Design Team', members: '24 members'),
                    const _GroupTile(name: 'Product Sync', members: '12 members'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 22.sp),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: AppColors.navy,
          ),
        ),
      ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({required this.name, required this.members});

  final String name;
  final String members;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          UserAvatar(name: name, size: 44),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  members,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.icon),
        ],
      ),
    );
  }
}
