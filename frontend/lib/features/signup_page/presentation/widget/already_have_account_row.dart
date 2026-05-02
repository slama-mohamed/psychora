import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:psychora/features/signup_page/presentation/function/navigation_functions.dart';

class AlreadyHaveAccountRow extends StatelessWidget {
  const AlreadyHaveAccountRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
          children: [
            TextSpan(
              text: 'Sign In',
              style: const TextStyle(
                color: Color(0xFF3D9970),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.3,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  AppNavigationFunctions.navigateToLogin(context);
                },
            ),
          ],
        ),
      ),
    );
  }
}