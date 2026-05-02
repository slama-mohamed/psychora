import 'package:flutter/material.dart';

/// Widget pour afficher la progression (Step + Percentage + Progress Bar)
class ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double percentage;

  const ProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Step $currentStep of $totalSteps",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
                letterSpacing: 0.3,
              ),
            ),
            Text(
              "${(percentage * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                color: Color(0xFF3D9970),
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: const AlwaysStoppedAnimation(Color(0xFF3D9970)),
          ),
        ),
      ],
    );
  }
}
