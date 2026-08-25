import 'package:messanger_ax/core/theme/app_colors.dart';
import 'package:messanger_ax/domain/models/user_story_item.dart';
import 'package:messanger_ax/domain/models/user_story_pack.dart';

abstract final class MockUserStories {
  static const packs = [
    UserStoryPack(
      name: 'David',
      online: true,
      ringColor: AppColors.primary,
      stories: [
        UserStoryItem(
          caption: 'Shipping the new dashboard today 🚀',
          timeAgo: '12m',
          colors: [AppColors.primary, AppColors.avatarViolet],
        ),
        UserStoryItem(
          caption: 'Coffee first. Then code.',
          timeAgo: '8m',
          colors: [AppColors.ink, AppColors.primaryDark],
        ),
      ],
    ),
    UserStoryPack(
      name: 'Nina',
      ringColor: AppColors.avatarCoral,
      stories: [
        UserStoryItem(
          caption: 'New illustrations are live ✨',
          timeAgo: '32m',
          colors: [AppColors.avatarCoral, AppColors.avatarViolet],
        ),
        UserStoryItem(
          caption: 'Mood board dump from this week',
          timeAgo: '18m',
          colors: [AppColors.avatarTeal, AppColors.avatarGreen],
        ),
        UserStoryItem(
          caption: 'Catch you all at the design sync',
          timeAgo: '5m',
          colors: [AppColors.avatarViolet, AppColors.ink],
        ),
      ],
    ),
    UserStoryPack(
      name: 'Alex',
      online: true,
      ringColor: AppColors.avatarViolet,
      stories: [
        UserStoryItem(
          caption: 'Standup notes are in Slack',
          timeAgo: '1h',
          colors: [AppColors.avatarViolet, AppColors.primary],
        ),
        UserStoryItem(
          caption: 'Weekend hiking recap ⛰️',
          timeAgo: '41m',
          colors: [AppColors.avatarGreen, AppColors.avatarTeal],
        ),
      ],
    ),
    UserStoryPack(
      name: 'Emma',
      ringColor: AppColors.primarySoft,
      stories: [
        UserStoryItem(
          caption: 'Drafted the launch copy. Thoughts?',
          timeAgo: '2h',
          colors: [AppColors.primarySoft, AppColors.primary],
        ),
      ],
    ),
  ];

  static int indexOf(String name) {
    return packs.indexWhere((pack) => pack.name == name);
  }
}
