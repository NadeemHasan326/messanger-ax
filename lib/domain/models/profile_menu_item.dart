import 'package:flutter/material.dart';

class ProfileMenuItem {
  const ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showThemeToggle = false,
    this.showNotificationToggle = false,
    this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool showThemeToggle;
  final bool showNotificationToggle;
  final String? route;
}
