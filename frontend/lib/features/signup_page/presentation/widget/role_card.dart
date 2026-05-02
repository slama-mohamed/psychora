import 'package:flutter/material.dart';


class RoleCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({super.key, 
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F9F6) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3D9970)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: const Color(0xFF3D9970).withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF3D9970)
                    : const Color(0xFFF0F9F6),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                imagePath,
                color: isSelected ? Colors.white : const Color(0xFF3D9970),
                errorBuilder: (context, error, stackTrace) => Icon(
                  label == 'Doctor'
                      ? Icons.medical_services_outlined
                      : Icons.school_outlined,
                  color: isSelected ? Colors.white : const Color(0xFF3D9970),
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF3D9970)
                    : const Color(0xFF6B7280),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}