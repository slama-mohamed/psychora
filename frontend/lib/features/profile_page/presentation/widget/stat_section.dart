import 'package:flutter/material.dart';
import 'package:psychora/features/profile_page/presentation/widget/stat_card.dart';

class StatSection extends StatelessWidget {
  const StatSection({
    super.key,
    required this.patientsCount,
    required this.sessionsCount,
    required this.rating,
  });

  final int patientsCount;
  final int sessionsCount;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: StatCard(number: patientsCount.toString(), label: 'Patients'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(number: sessionsCount.toString(), label: 'Sessions'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(number: rating.toStringAsFixed(1), label: 'Rating'),
          ),
        ],
      ),
    );
  }
}
