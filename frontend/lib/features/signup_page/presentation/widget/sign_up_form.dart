import 'package:flutter/material.dart';
import 'package:psychora/core/constants/assets_constant.dart';
import 'package:psychora/core/validators/signup_form_validator.dart';
import '../function/signup_controller.dart';
import 'fullname_field.dart';
import 'email_field.dart';
import 'password_field.dart';
import 'role_selector.dart';
import '../widget/already_have_account_row.dart';
import '../../../login_page/presentation/widget/welcome_text.dart';

class SignupForm extends StatefulWidget {
  final SignupController controller;

  const SignupForm({super.key, required this.controller});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.fullNameController.addListener(_onChanged);
    widget.controller.emailController.addListener(_onChanged);
    widget.controller.passwordController.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.fullNameController.removeListener(_onChanged);
    widget.controller.emailController.removeListener(_onChanged);
    widget.controller.passwordController.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _isFormValid => SignupFormValidator.validateAll(
        fullName: widget.controller.fullNameController.text,
        email: widget.controller.emailController.text,
        password: widget.controller.passwordController.text,
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE8F5E9),
                          ),
                          child: const Icon(
                            Icons.psychology_outlined,
                            color: Color(0xFF3D9970),
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const WelcomeText(
                    title: 'Create Account',
                    subtitle: 'Join the Psychora community',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: widget.controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoleSelector(
                      selectedRole: widget.controller.selectedRole,
                      onRoleChanged: (role) {
                        setState(() => widget.controller.selectedRole = role);
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'FULL NAME',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FullNameField(controller: widget.controller.fullNameController),
                    const SizedBox(height: 20),
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
                    EmailField(controller: widget.controller.emailController),
                    const SizedBox(height: 20),
                    const Text(
                      'PASSWORD',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    PasswordFieldSignup(controller: widget.controller.passwordController),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isFormValid
                            ? () {
                                if (widget.controller.formKey.currentState!
                                    .validate()) {
                                  widget.controller.onContinue(context);
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid
                              ? const Color(0xFF3D9970)
                              // ignore: deprecated_member_use
                              : const Color(0xFF3D9970).withOpacity(0.5),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const AlreadyHaveAccountRow(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}