import 'package:flutter/material.dart';

class PatientCard extends StatelessWidget {
  final String patientName;
  final String patientId;
  final int age;
  final String condition;
  final String? nextVisit;
  final int sessionsCount;
  final VoidCallback? onContinueChat;
  final VoidCallback? onEdit;
  final VoidCallback? onSummary;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const PatientCard({
    super.key,
    required this.patientName,
    required this.patientId,
    required this.age,
    required this.condition,
    this.nextVisit,
    required this.sessionsCount,
    this.onContinueChat,
    this.onEdit,
    this.onSummary,
    this.onDelete,
    this.onTap,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    return parts[0][0].toUpperCase();
  }

  static const List<Color> _avatarBgColors = [
    Color(0xFFFFCDD2),
    Color(0xFFBBDEFB),
    Color(0xFFFFF9C4),
    Color(0xFFC8E6C9),
    Color(0xFFE1BEE7),
    Color(0xFFFFE0B2),
    Color(0xFFB2EBF2),
    Color(0xFFF8BBD0),
  ];

  static const List<Color> _avatarTextColors = [
    Color(0xFFE53935),
    Color(0xFF1E88E5),
    Color(0xFFF9A825),
    Color(0xFF43A047),
    Color(0xFF8E24AA),
    Color(0xFFFB8C00),
    Color(0xFF00ACC1),
    Color(0xFFD81B60),
  ];

  Color _getConditionColor(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('diagnosis not yet established') || c.contains('not yet established')) {
      return const Color(0xFFFEE2E2);
    }
    if (c.contains('depressive') || c.contains('dépressif')) return const Color(0xFFFFCDD2);
    if (c.contains('anxiety') || c.contains('anxiété')) return const Color(0xFFFFE0B2);
    if (c.contains('ptsd') || c.contains('stress')) return const Color(0xFFE1BEE7);
    if (c.contains('sleep') || c.contains('sommeil')) return const Color(0xFFBBDEFB);
    if (c.contains('bipolar') || c.contains('bipolaire')) return const Color(0xFFF8BBD0);
    return const Color(0xFFC8E6C9);
  }

  Color _getConditionTextColor(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('diagnosis not yet established') || c.contains('not yet established')) {
      return const Color(0xFF991B1B);
    }
    return Colors.grey[700]!;
  }

  Color _getAvatarBgColor(String name) {
    final int index = name.isEmpty ? 0 : name.codeUnitAt(0) % _avatarBgColors.length;
    return _avatarBgColors[index];
  }

  Color _getAvatarTextColor(String name) {
    final int index = name.isEmpty ? 0 : name.codeUnitAt(0) % _avatarTextColors.length;
    return _avatarTextColors[index];
  }

  DateTime? _parseNextVisit(String? nextVisit) {
    if (nextVisit == null || nextVisit.trim().isEmpty) {
      return null;
    }

    final String value = nextVisit.trim();
    final DateTime? isoDate = DateTime.tryParse(value);
    if (isoDate != null) {
      return isoDate;
    }

    final String normalized = value.replaceAll(' ', 'T');
    final DateTime? normalizedDate = DateTime.tryParse(normalized);
    if (normalizedDate != null) {
      return normalizedDate;
    }

    final RegExp datePattern = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2})(?::(\d{2}))?$',
    );
    final Match? match = datePattern.firstMatch(value);
    if (match != null) {
      return DateTime(
        int.parse(match.group(1)!),
        int.parse(match.group(2)!),
        int.parse(match.group(3)!),
        int.parse(match.group(4)!),
        int.parse(match.group(5)!),
        match.group(6) != null ? int.parse(match.group(6)!) : 0,
      );
    }

    return null;
  }

  String _formatNextVisit(String? nextVisit) {
    final DateTime? date = _parseNextVisit(nextVisit);
    if (date == null) {
      return 'No next visit';
    }

    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString().substring(2);
    final String hour = date.hour.toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year à ${hour}h$minute';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _getAvatarBgColor(patientName),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _getInitials(patientName),
                      style: TextStyle(
                        color: _getAvatarTextColor(patientName),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _getConditionColor(condition),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            condition,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getConditionTextColor(condition),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cake_outlined, size: 14, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 4),
                  Text(
                    '$age years',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 4),
                  Text(
                    _formatNextVisit(nextVisit),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.chat_bubble_outline, size: 14, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 4),
                  Text(
                    '$sessionsCount sessions',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: onContinueChat,
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 16,
                        ),
                        label: const Text(
                          'Continue Chat',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D9970),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: onSummary,
                      icon: const Icon(
                        Icons.summarize_outlined,
                        size: 18,
                        color: Color(0xFF6B7280),
                      ),
                      tooltip: 'Summary',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Color(0xFF0284C7),
                      ),
                      tooltip: 'Update patient',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Color(0xFFDC2626),
                      ),
                      tooltip: 'Delete patient',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}