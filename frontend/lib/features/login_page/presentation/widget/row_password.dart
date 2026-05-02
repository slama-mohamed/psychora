import 'package:flutter/material.dart';
import 'package:psychora/features/login_page/presentation/function/handle_forgot_password.dart';

class RowPassword extends StatelessWidget {
  const RowPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PASSWORD',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.5,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle forgot password
                    handleForgotPassword( context);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'FORGOT?',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3D9970),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            );
  }
}