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
