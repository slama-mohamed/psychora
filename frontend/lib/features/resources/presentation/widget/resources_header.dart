import 'package:flutter/material.dart';

// ─── App theme color ──────────────────────────────────────────────────────────
const kGreen = Color(0xFF3D9970);
const kGreenLight = Color(0xFFE8F5E9);
const kGreenMid = Color(0xFF43A047);

class ResourcesHeader extends StatelessWidget {
  const ResourcesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: kGreenLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: kGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Medical Resources',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Text(
              'Various Resources — tap to open',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}