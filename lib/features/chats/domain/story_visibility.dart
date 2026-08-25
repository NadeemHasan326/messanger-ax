import 'package:messanger_ax/core/constants/app_enums.dart';
import 'package:messanger_ax/features/chats/data/mock_story_contacts.dart';

abstract final class StoryVisibility {
  static List<String> resolveViewers({
    required StoryPrivacy privacy,
    required List<String> selectedContactNames,
  }) {
    return switch (privacy) {
      StoryPrivacy.everyone ||
      StoryPrivacy.contacts =>
        MockStoryContacts.all.map((contact) => contact.name).toList(),
      StoryPrivacy.selected => List<String>.from(selectedContactNames),
    };
  }
}
