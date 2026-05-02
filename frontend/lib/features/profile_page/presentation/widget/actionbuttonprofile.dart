import 'package:flutter/material.dart';

class Actionbuttonprofile extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const Actionbuttonprofile({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}