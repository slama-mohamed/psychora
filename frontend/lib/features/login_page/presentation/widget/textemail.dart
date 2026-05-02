import 'package:flutter/material.dart';

class Textemail extends StatelessWidget {
  const Textemail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
              'EMAIL ADDRESS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            );
  }
}