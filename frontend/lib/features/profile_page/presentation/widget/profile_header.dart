import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String initials;
  final String name;
  final String profession;
  final bool isAvailable;

  const ProfileHeader({
    super.key,
    required this.initials,
    required this.name,
    required this.profession,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3D9970),
                Color(0xFF2d7a5c),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3D9970).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.transparent,
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Nom
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F2937),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),

        // Profession
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF3D9970).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            profession,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3D9970),
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Statut
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isAvailable ? const Color(0xFF10B981) : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              isAvailable ? 'Available' : 'Unavailable',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}