import 'package:flutter/material.dart';

class QuickActionItem {
  const QuickActionItem({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
}
