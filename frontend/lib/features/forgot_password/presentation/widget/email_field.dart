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
    }
  }

  void _onEmailChanged() {
    setState(() {});
  }

  InputBorder _getInputBorder() {
    if (!_hasInteracted) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      );
    }

    if (widget.controller.text.isEmpty) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      );
    }

    if (ValidationPatterns.isValidEmail(widget.controller.text)) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3D9970), width: 1),
      );
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red, width: 1),
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
      validator: EmailValidator.validate,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
