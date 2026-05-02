import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psychora/features/home/presentation/widget/recentactivityitem.dart';
import 'package:psychora/features/patients/domain/models/patient.dart';
import 'package:psychora/features/patients/presentation/providers/patient_provider.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  static const List<Color> _avatarBackgrounds = <Color>[
    Color(0xFFD7F3E8),
    Color(0xFFDDEBFF),
    Color(0xFFF0E0FF),
    Color(0xFFFFF1E3),
    Color(0xFFE8F5E9),
    Color(0xFFF8E1FF),
  ];

  static const List<Color> _avatarForegrounds = <Color>[
    Color(0xFF2E8B57),
    Color(0xFF3B82F6),
    Color(0xFFA855F7),
    Color(0xFFB55620),
    Color(0xFF2F855A),
    Color(0xFF8B5CF6),
  ];

  Color _avatarBackgroundColor(String name) {
    final int index = name.isEmpty ? 0 : name.codeUnitAt(0) % _avatarBackgrounds.length;
    return _avatarBackgrounds[index];
  }

  Color _avatarForegroundColor(String name) {
    final int index = name.isEmpty ? 0 : name.codeUnitAt(0) % _avatarForegrounds.length;
    return _avatarForegrounds[index];
  }

  String _formatSessionTime(String? nextVisit) {
    if (nextVisit == null || nextVisit.trim().isEmpty) {
      return 'No visit';
    }
    final DateTime? date = DateTime.tryParse(nextVisit);
    if (date == null) {
      return 'No visit';
    }
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final List<Patient> todayPatients = context.watch<PatientProvider>().todayPatients;
    final List<RecentActivityItem> todaySessions = todayPatients.map((Patient patient) {
      return RecentActivityItem(
        name: patient.name,
        diagnosis: patient.condition,
        time: _formatSessionTime(patient.nextVisit),
        avatarBackgroundColor: _avatarBackgroundColor(patient.name),
        avatarForegroundColor: _avatarForegroundColor(patient.name),
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAECEF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: Color(0xFF3D9970),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Today's sessions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (todaySessions.isEmpty)
            Center(
              child: Column(
                children: const [
                  SizedBox(height: 20),
                  Text(
                    'No sessions today',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add a visit date to a patient to see it here.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            )
          else
            ...todaySessions.asMap().entries.map((entry) {
              final int index = entry.key;
              final RecentActivityItem item = entry.value;
              return Column(
                children: [
                  _TodaySessionCard(item: item),
                  if (index < todaySessions.length - 1)
                    const SizedBox(height: 10),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class _TodaySessionCard extends StatelessWidget {
  const _TodaySessionCard({required this.item});

  final RecentActivityItem item;

  @override
  Widget build(BuildContext context) {
    final initial = item.name.isNotEmpty ? item.name[0].toUpperCase() : '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.avatarBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: TextStyle(
                color: item.avatarForegroundColor,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _TimePill(time: item.time),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        item.diagnosis,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _ActionChip(
            backgroundColor: const Color(0xFFFFF6DB),
            borderColor: const Color(0xFFF5D36A),
            icon: Icons.description_outlined,
            iconColor: const Color(0xFFB7791F),
          ),
          const SizedBox(width: 8),
          _ActionChip(
            backgroundColor: const Color(0xFFEAF7F0),
            borderColor: const Color(0xFFCDE9DA),
            icon: Icons.chat_bubble_outline,
            iconColor: const Color(0xFF5B8C72),
          ),
        ],
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  const _TimePill({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD7E7DE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule_outlined,
            size: 12,
            color: Color(0xFF5B8C72),
          ),
          const SizedBox(width: 4),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF4B5563),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.backgroundColor,
    required this.borderColor,
    required this.icon,
    required this.iconColor,
  });

  final Color backgroundColor;
  final Color borderColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Icon(
        icon,
        size: 18,
        color: iconColor,
      ),
    );
  }
}