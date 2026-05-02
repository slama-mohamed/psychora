// lib/widgets/action_button.dart

import 'package:flutter/material.dart';

class Actionbuttondashboard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const Actionbuttondashboard({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Tooltip(
        message: label,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  icon,
                  color: const Color(0xFF3D9970),
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}