import 'package:flutter/material.dart';
import 'package:psychora/core/validators/password_validator.dart';
import 'package:psychora/core/styles/form_styles.dart';

class PasswordFieldSignup extends StatefulWidget {
  final TextEditingController controller;

  const PasswordFieldSignup({super.key, required this.controller});

  @override
  State<PasswordFieldSignup> createState() => _PasswordFieldSignupState();
}

class _PasswordFieldSignupState extends State<PasswordFieldSignup> {
  bool _obscure = true;
  late FocusNode _focusNode;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && !_hasInteracted) {
      setState(() {
        _hasInteracted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscure,
      autovalidateMode: _hasInteracted
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      style: FormStyles.inputTextStyle,
      validator: PasswordValidator.validate,
      decoration: FormStyles.baseDecoration(icon: Icons.lock_outline, hint: 'Password').copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: FormStyles.iconColor,
            size: 20,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}