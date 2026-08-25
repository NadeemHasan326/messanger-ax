import 'package:flutter/material.dart';

class StatusItem {
  const StatusItem({
    required this.name,
    this.isMine = false,
    this.hasUpdate = false,
    this.online = false,
    this.ringColor,
    this.visibilityLabel,
  });

  final String name;
  final bool isMine;
  final bool hasUpdate;
  final bool online;
  final Color? ringColor;
  final String? visibilityLabel;
}
