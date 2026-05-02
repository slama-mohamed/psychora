import 'package:flutter/material.dart';
import 'package:psychora/features/login_page/presentation/function/handle_signup_navigation.dart';

class LastRow extends StatelessWidget {
  const LastRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'New to Psychora?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(width: 6),
          GestureDetector(
            onTap: () => handleSignupNavigation(context),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: Color(0xFF3D9970),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
