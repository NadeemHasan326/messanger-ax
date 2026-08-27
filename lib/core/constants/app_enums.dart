/// Shared enums used across the app.
library;

enum CallType { incoming, outgoing, missed }

enum CallDateFilter { all, today, yesterday, thisWeek }

enum SearchResultType { chat, contact, call }

enum MessageStatus { none, sent, delivered, read }

enum AppToastType { info, success, error, warning }

enum AppToastPosition { top, bottom }

enum StoryType { camera, gallery, text }

enum StoryPrivacy { everyone, contacts, selected }

enum ChatLocationType { current, live }

enum ChatMenuAction {
  viewProfile,
  mute,
  clearChat,
  block,
  addMembers,
  sendPermission,
  viewMembers,
  wallpaper,
  channelInfo,
  unfollow,
  addToContacts,
  search,
  mediaLinksDocs,
  chatLock,
  hideChat,
  disappearing,
  more,
  report,
  exportChat,
  addShortcut,
  addToList,
}

enum ChatWallpaper {
  system,
  dusk,
  sage,
  sand,
  slate,
  mist,
  gallery;

  String get label => switch (this) {
        system => 'Default',
        dusk => 'Dusk',
        sage => 'Sage',
        sand => 'Sand',
        slate => 'Slate',
        mist => 'Mist',
        gallery => 'Choose from gallery',
      };
}

enum DisappearingDuration {
  off,
  hours24,
  days3,
  days7,
  days30,
  days90;

  String get label => switch (this) {
        off => 'Off',
        hours24 => '24 hours',
        days3 => '3 days',
        days7 => '7 days',
        days30 => '30 days',
        days90 => '90 days',
      };

  Duration? get ttl => switch (this) {
        off => null,
        hours24 => const Duration(hours: 24),
        days3 => const Duration(days: 3),
        days7 => const Duration(days: 7),
        days30 => const Duration(days: 30),
        days90 => const Duration(days: 90),
      };
}

/// Entrance slide direction for fade/slide animations.
enum SlideDirection {
  fromRight,
  fromLeft,
  fromTop,
  fromBottom,
  fromTopLeft,
  fromTopRight,
  fromBottomLeft,
  fromBottomRight,
}
