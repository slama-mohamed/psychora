import 'package:flutter/material.dart';

class PsychoraText extends StatelessWidget {
  const PsychoraText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Psychora',
      style: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.bold,
        fontFamily: "myfont",
        color: Color(0xFF111827),
        letterSpacing: -0.5,
      ),
    );
  }
}
