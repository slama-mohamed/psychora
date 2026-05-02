import 'package:flutter/material.dart';
import 'package:psychora/core/constants/assets_constant.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/reset_password/presentation/widget/password_field.dart';
import 'package:psychora/features/reset_password/presentation/widget/confirm_password_field.dart';
import 'package:psychora/features/reset_password/presentation/widget/reset_button.dart';
import 'package:psychora/features/reset_password/presentation/function/handle_login_navigation.dart';

class Resetpasswordform extends StatefulWidget {
  final String? email;
  final String? token;

  const Resetpasswordform({super.key, this.email, this.token});

  @override
  State<Resetpasswordform> createState() => _ResetpasswordformState();
}

class _ResetpasswordformState extends State<Resetpasswordform> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitResetPassword() async {
    if (_isSubmitting) return;

    final FormState? formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _apiService.resetPassword(
        newPassword: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
        email: widget.email,
        token: widget.token,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully.'),
          backgroundColor: Color(0xFF3D9970),
        ),
      );
      handleLoginNavigation(context);
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
                            // ignore: deprecated_member_use
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
                    const Text(
                      'Create New Password',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your new password and confirm it',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
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
                      // ignore: deprecated_member_use
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
                      'NEW PASSWORD',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    PasswordField(controller: _passwordController),
                    const SizedBox(height: 24),
                    const Text(
                      'CONFIRM PASSWORD',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ConfirmPasswordField(
                      controller: _confirmPasswordController,
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: 28),
                    ResetButton(
                      isLoading: _isSubmitting,
                      onPressed: _submitResetPassword,
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