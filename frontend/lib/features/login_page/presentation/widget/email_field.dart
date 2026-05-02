import 'package:flutter/material.dart';
import 'package:psychora/core/validators/email_validator.dart';
import 'package:psychora/core/validators/validation_patterns.dart';

class EmailField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const EmailField({
    super.key,
    required this.controller,
    this.focusNode,
  });

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  late FocusNode _focusNode;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    widget.controller.removeListener(_onEmailChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && !_hasInteracted) {
      setState(() {
        _hasInteracted = true;
      });
    } else {
      setState(() {});
    }
  }

  void _onEmailChanged() {
    setState(() {});
  }

  InputBorder _getInputBorder() {
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
              : const Color(0xFFE5E7EB),
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
      autovalidateMode: _hasInteracted ? AutovalidateMode.always : AutovalidateMode.disabled,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF1F2937),
      ),
      validator: (value) {
        if (!_hasInteracted) return null;
        return EmailValidator.validate(value);
      },
      decoration: InputDecoration(
        hintText: 'Enter your email',
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 15,
        ),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: Color(0xFF9CA3AF),
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: _getInputBorder(),
        focusedBorder: _getInputBorder(),
        errorBorder: _getInputBorder(),
        focusedErrorBorder: _getInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}