import 'package:flutter/material.dart';
import 'package:psychora/core/validators/email_validator.dart';
import 'package:psychora/core/validators/validation_patterns.dart';
import 'package:psychora/core/styles/form_styles.dart';

class EmailField extends StatefulWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  late FocusNode _focusNode;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(() => setState(() {}));
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
        _hasInteracted = true; // active la validation après le premier blur
      });
    } else {
      setState(() {}); // redraw pour border vert/rouge pendant l'écriture
    }
  }

  InputBorder _getBorder() {
    final isValid = ValidationPatterns.isValidEmail(widget.controller.text);

    if (_focusNode.hasFocus) {
      // Focus actif → vert si valide, rouge si invalide
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: widget.controller.text.isEmpty || !isValid
              ? Colors.red
              : const Color(0xFF3D9970),
          width: 1,
        ),
      );
    }

    if (_hasInteracted) {
      // Focus perdu
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: widget.controller.text.isEmpty || !isValid
              ? Colors.red
              : const Color(0xFFE5E7EB), // gris si valide
          width: 1,
        ),
      );
    }

    // Jamais touché → gris
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: _hasInteracted
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      style: FormStyles.inputTextStyle,
      validator: (value) {
        if (!_hasInteracted) return null; // pas de message avant le premier blur
        return EmailValidator.validate(value);
      },
      decoration: FormStyles.baseDecoration(
        icon: Icons.email_outlined,
        hint: 'Enter your email',
      ).copyWith(
        enabledBorder: _getBorder(),
        focusedBorder: _getBorder(),
        errorBorder: _getBorder(),
        focusedErrorBorder: _getBorder(),
      ),
    );
  }
}