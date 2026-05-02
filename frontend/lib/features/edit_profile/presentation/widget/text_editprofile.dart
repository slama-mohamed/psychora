import 'package:flutter/material.dart';

class TextEditprofile extends StatelessWidget {
  const TextEditprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Edit Profile',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        height: 1.1,
        color: Color(0xFF1F2937),
      ),
    );
  }
}
