import 'package:messanger_ax/core/constants/app_enums.dart';

class PostedStory {
  const PostedStory({
    required this.type,
    required this.privacy,
    required this.viewerNames,
    this.caption,
    this.selectedContactNames = const [],
  });

  final StoryType type;
  final StoryPrivacy privacy;
  final List<String> viewerNames;
  final String? caption;
  final List<String> selectedContactNames;

  int get viewerCount => viewerNames.length;

  String get privacyLabel => switch (privacy) {
        StoryPrivacy.everyone => 'Everyone',
        StoryPrivacy.contacts => 'Contacts',
        StoryPrivacy.selected =>
          '${selectedContactNames.length} selected contact${selectedContactNames.length == 1 ? '' : 's'}',
      };

  String get visibilityLabel => 'Visible to $viewerCount';
}
