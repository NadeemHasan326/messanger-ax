import 'package:messanger_ax/exports.dart';

class PrivacySecurityPage extends GetView<PrivacySecurityController> {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const ProfileSettingsHeader(
              title: 'Privacy & Security',
              subtitle: 'Blocked contacts, 2FA',
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
                children: [
                  Obx(
                    () => SettingsGroupCard(
                      title: 'Who can see my info',
                      children: [
                        SettingsListTile(
                          title: 'Last seen & online',
                          trailingText: controller.lastSeen.value,
                          onTap: () => controller.pickVisibility(
                            'Last seen & online',
                            controller.lastSeen,
                          ),
                        ),
                        SettingsListTile(
                          title: 'Profile photo',
                          trailingText: controller.profilePhoto.value,
                          onTap: () => controller.pickVisibility(
                            'Profile photo',
                            controller.profilePhoto,
                          ),
                        ),
                        SettingsListTile(
                          title: 'About',
                          trailingText: controller.aboutVisibility.value,
                          onTap: () => controller.pickVisibility(
                            'About',
                            controller.aboutVisibility,
                          ),
                        ),
                        SettingsListTile(
                          title: 'Status',
                          trailingText: controller.statusVisibility.value,
                          onTap: () => controller.pickVisibility(
                            'Status',
                            controller.statusVisibility,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Obx(
                    () => SettingsGroupCard(
                      title: 'Messages',
                      children: [
                        SettingsListTile(
                          title: 'Read receipts',
                          subtitle: 'If off, you won’t send or see read ticks',
                          switchValue: controller.readReceipts.value,
                          onSwitchChanged: controller.toggleReadReceipts,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Obx(
                    () => SettingsGroupCard(
                      title: 'Security',
                      children: [
                        SettingsListTile(
                          title: 'Two-step verification',
                          subtitle: 'PIN required when registering your number',
                          switchValue: controller.twoStepVerification.value,
                          onSwitchChanged: controller.toggleTwoStep,
                        ),
                        SettingsListTile(
                          title: 'Screen lock',
                          subtitle: 'Lock Messanger AX with Face ID or PIN',
                          switchValue: controller.screenLock.value,
                          onSwitchChanged: controller.toggleScreenLock,
                        ),
                        SettingsListTile(
                          title: 'Login alerts',
                          subtitle: 'Get notified of new device logins',
                          switchValue: controller.loginAlerts.value,
                          onSwitchChanged: controller.toggleLoginAlerts,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  SettingsGroupCard(
                    title: 'Blocked contacts',
                    children: [
                      Obx(() {
                        if (controller.blocked.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 16.h,
                            ),
                            child: Text(
                              'No blocked contacts',
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                color: AppColors.muted,
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            for (var i = 0;
                                i < controller.blocked.length;
                                i++) ...[
                              _BlockedTile(contact: controller.blocked[i]),
                              if (i != controller.blocked.length - 1)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                  ),
                                  child: Divider(
                                    height: 1,
                                    color: AppColors.divider,
                                  ),
                                ),
                            ],
                          ],
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

class _BlockedTile extends StatelessWidget {
  const _BlockedTile({required this.contact});

  final BlockedContact contact;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrivacySecurityController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          UserAvatar(name: contact.name, size: 40),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Blocked ${contact.blockedOn}',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5.sp,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => controller.unblock(contact),
            child: Text(
              'Unblock',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
