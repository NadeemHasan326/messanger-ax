import 'package:flutter/material.dart';
import 'package:messanger_ax/domain/models/user_story_item.dart';

class UserStoryPack {
  const UserStoryPack({
    required this.name,
    required this.stories,
    this.online = false,
    this.ringColor,
  });

  final String name;
  final List<UserStoryItem> stories;
  final bool online;
  final Color? ringColor;
}
