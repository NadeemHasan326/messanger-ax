import 'package:messanger_ax/domain/models/story_contact.dart';

/// Mock contacts used for story privacy (everyone / contacts / selected).
abstract final class MockStoryContacts {
  static const all = [
    StoryContact(name: 'Alex Rivera', role: 'Product Manager', section: 'A'),
    StoryContact(name: 'Ava Thompson', role: 'UX Designer', section: 'A'),
    StoryContact(name: 'Benjamin Lee', role: 'iOS Engineer', section: 'B'),
    StoryContact(name: 'Chloe Martinez', role: 'Marketing Lead', section: 'C'),
    StoryContact(name: 'Daniel Brooks', role: 'Backend Engineer', section: 'D'),
    StoryContact(name: 'Emma Thompson', role: 'Content Strategist', section: 'E'),
    StoryContact(name: 'Nina Williams', role: 'Product Designer', section: 'N'),
    StoryContact(name: 'Olivia Williams', role: 'Marketing Lead', section: 'O'),
    StoryContact(name: 'David Chen', role: 'Engineering Lead', section: 'D'),
    StoryContact(name: 'Liam Neeson', role: 'Sales Director', section: 'L'),
  ];
}
