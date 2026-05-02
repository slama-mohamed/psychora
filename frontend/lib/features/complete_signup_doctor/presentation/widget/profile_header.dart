import 'package:flutter/material.dart';
import 'package:psychora/core/constants/assets_constant.dart';

/// Widget pour le header (logo + titre + sous-titre)
class ProfileHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? logoPath;

  const ProfileHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLogo(),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D9970).withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        logoPath ?? AssetsConstant.appLogos,
        width: 110,
        height: 110,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE8F5E9),
            ),
            child: const Icon(
              Icons.psychology_outlined,
              color: Color(0xFF3D9970),
              size: 50,
            ),
          );
        },
      ),
    );
  }
}
