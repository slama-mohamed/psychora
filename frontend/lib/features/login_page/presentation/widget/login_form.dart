import 'package:flutter/material.dart';
import 'package:psychora/core/constants/assets_constant.dart';
import 'package:psychora/features/login_page/presentation/function/handle_home_navigation.dart';
import 'package:psychora/features/login_page/presentation/widget/email_field.dart';
import 'package:psychora/features/login_page/presentation/widget/last_row.dart';
import 'package:psychora/features/login_page/presentation/widget/login_button.dart';
import 'package:psychora/features/login_page/presentation/widget/password_field.dart';
import 'package:psychora/features/login_page/presentation/widget/row_password.dart';
import 'package:psychora/features/login_page/presentation/widget/textemail.dart';
import 'package:psychora/features/login_page/presentation/widget/welcome_text.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24),
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
                    SizedBox(height: 32),
                    const WelcomeText(subtitle: 'Welcome back to your workspace'),
                  ],
                ),
              ),
              SizedBox(height: 40),
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
                    Textemail(),
                    SizedBox(height: 10),
                    EmailField(controller: _emailController),
                    SizedBox(height: 24),
                    RowPassword(),
                    SizedBox(height: 10),
                    PasswordField(controller: _passwordController),
                    SizedBox(height: 28),
                    LoginButton(onPressed: () => handleHomeNavigation(
                      context: context,
                      email: _emailController.text,
                      password: _passwordController.text,
                    )),
                  ],
                ),
              ),
              SizedBox(height: 24),
              LastRow(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
