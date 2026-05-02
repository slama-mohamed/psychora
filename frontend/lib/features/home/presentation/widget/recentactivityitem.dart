import 'dart:ui';

class RecentActivityItem {
  final String name;
  final String diagnosis;
  final String time;
  final Color avatarBackgroundColor;
  final Color avatarForegroundColor;

  const RecentActivityItem({
    required this.name,
    required this.diagnosis,
    required this.time,
    required this.avatarBackgroundColor,
    this.avatarForegroundColor = const Color(0xFF1F2937),
  });
}