import 'package:flutter/material.dart';

class UserProfile {
  const UserProfile({
    required this.name,
    required this.username,
    required this.bio,
    required this.role,
    required this.posts,
    required this.followers,
    required this.following,
    required this.postColors,
    this.online = false,
  });

  final String name;
  final String username;
  final String bio;
  final String role;
  final String posts;
  final String followers;
  final String following;
  final List<List<Color>> postColors;
  final bool online;
}
