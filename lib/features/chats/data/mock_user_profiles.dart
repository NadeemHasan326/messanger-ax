import 'package:messanger_ax/core/theme/app_colors.dart';
import 'package:messanger_ax/domain/models/user_profile.dart';

abstract final class MockUserProfiles {
  static const profiles = [
    UserProfile(
      name: 'David',
      username: 'david.chen',
      bio: 'Engineering Lead at Virexon.\nShipping the new dashboard 🚀',
      role: 'Engineering Lead',
      posts: '24',
      followers: '2.4K',
      following: '186',
      online: true,
      postColors: [
        [AppColors.primary, AppColors.avatarViolet],
        [AppColors.ink, AppColors.primaryDark],
        [AppColors.avatarTeal, AppColors.avatarGreen],
        [AppColors.avatarViolet, AppColors.primary],
        [AppColors.avatarCoral, AppColors.avatarViolet],
        [AppColors.primarySoft, AppColors.primary],
        [AppColors.avatarGreen, AppColors.avatarTeal],
        [AppColors.ink, AppColors.avatarViolet],
        [AppColors.primary, AppColors.avatarSky],
      ],
    ),
    UserProfile(
      name: 'Nina',
      username: 'nina.designs',
      bio: 'Product Designer.\nNew illustrations every week ✨',
      role: 'Product Designer',
      posts: '41',
      followers: '8.1K',
      following: '312',
      postColors: [
        [AppColors.avatarCoral, AppColors.avatarViolet],
        [AppColors.avatarTeal, AppColors.avatarGreen],
        [AppColors.avatarViolet, AppColors.ink],
        [AppColors.primary, AppColors.avatarCoral],
        [AppColors.avatarSky, AppColors.primarySoft],
        [AppColors.avatarGreen, AppColors.ink],
        [AppColors.avatarCoral, AppColors.primary],
        [AppColors.avatarViolet, AppColors.avatarTeal],
        [AppColors.ink, AppColors.primaryDark],
      ],
    ),
    UserProfile(
      name: 'Alex',
      username: 'alex.rivera',
      bio: 'Product Manager.\nWeekend hiker ⛰️',
      role: 'Product Manager',
      posts: '18',
      followers: '1.1K',
      following: '240',
      online: true,
      postColors: [
        [AppColors.avatarViolet, AppColors.primary],
        [AppColors.avatarGreen, AppColors.avatarTeal],
        [AppColors.ink, AppColors.avatarSky],
        [AppColors.primarySoft, AppColors.avatarViolet],
        [AppColors.avatarCoral, AppColors.ink],
        [AppColors.primary, AppColors.avatarGreen],
        [AppColors.avatarTeal, AppColors.primaryDark],
        [AppColors.avatarViolet, AppColors.avatarCoral],
        [AppColors.ink, AppColors.primary],
      ],
    ),
    UserProfile(
      name: 'Emma',
      username: 'emma.writes',
      bio: 'Content Strategist.\nLaunch copy, always in draft.',
      role: 'Content Strategist',
      posts: '33',
      followers: '3.6K',
      following: '198',
      postColors: [
        [AppColors.primarySoft, AppColors.primary],
        [AppColors.avatarCoral, AppColors.avatarSky],
        [AppColors.ink, AppColors.avatarViolet],
        [AppColors.avatarGreen, AppColors.primarySoft],
        [AppColors.primary, AppColors.ink],
        [AppColors.avatarTeal, AppColors.avatarCoral],
        [AppColors.avatarViolet, AppColors.primarySoft],
        [AppColors.avatarSky, AppColors.ink],
        [AppColors.primaryDark, AppColors.avatarGreen],
      ],
    ),
  ];

  static UserProfile byName(String name) {
    return profiles.firstWhere(
      (profile) => profile.name == name,
      orElse: () => profiles.first,
    );
  }
}
