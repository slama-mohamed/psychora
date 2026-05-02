// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:psychora/core/constants/assets_constant.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/forgot_password/presentation/widget/mytext.dart';
import 'package:psychora/features/forgot_password/presentation/widget/reset_button.dart';
import 'package:psychora/features/forgot_password/presentation/widget/email_field.dart';

class Forgotpasswordform extends StatefulWidget {
  const Forgotpasswordform({super.key});

  @override
  State<Forgotpasswordform> createState() => _ForgotpasswordformState();
}

class _ForgotpasswordformState extends State<Forgotpasswordform> {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (_isSubmitting) return;

    final FormState? formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _apiService.requestPasswordResetLink(
        email: _emailController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A password reset link has been sent to your email.'),
          backgroundColor: Color(0xFF3D9970),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              // Header with logo and title
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3D9970).withOpacity(0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AssetsConstant.appLogo,
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 140,
                            height: 140,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE8F5E9),
                            ),
                            child: const Icon(
                              Icons.psychology_outlined,
                              color: Color(0xFF3D9970),
                              size: 60,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    Mytext(),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Form card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EMAIL ADDRESS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    EmailField(controller: _emailController),
                    const SizedBox(height: 28),
                    ResetButton(
                      isLoading: _isSubmitting,
                      onPressed: _sendResetLink,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
