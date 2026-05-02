import 'package:flutter/material.dart';

class QuickActionItem {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onTap;

  const QuickActionItem({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    this.onTap,
  });
}