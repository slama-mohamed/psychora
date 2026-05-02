import 'package:flutter/material.dart';
import 'package:psychora/features/login_page/presentation/widget/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF0F9F6),
                  const Color(0xFFFBFDFC),
                  const Color(0xFFF5F8FA),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Decorative blur circles top-left
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // ignore: deprecated_member_use
                color: const Color(0xFF3D9970).withOpacity(0.08),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: const Color(0xFF3D9970).withOpacity(0.05),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          // Decorative blur circles bottom-right
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // ignore: deprecated_member_use
                color: const Color(0xFF3D9970).withOpacity(0.06),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: const Color(0xFF3D9970).withOpacity(0.04),
                    blurRadius: 100,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    LoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}