import 'package:flutter/material.dart';

class UserStoryItem {
  const UserStoryItem({
    required this.caption,
    required this.timeAgo,
    required this.colors,
  });

  final String caption;
  final String timeAgo;
  final List<Color> colors;
}
