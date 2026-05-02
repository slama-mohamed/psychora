import 'package:flutter/material.dart';
import 'package:psychora/core/validators/fullname_validator.dart';
import 'package:psychora/core/styles/form_styles.dart';

class FullNameField extends StatefulWidget {
  final TextEditingController controller;

  const FullNameField({super.key, required this.controller});

  @override
  State<FullNameField> createState() => _FullNameFieldState();
}

class _FullNameFieldState extends State<FullNameField> {
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
      textCapitalization: TextCapitalization.words,
      autovalidateMode: _hasInteracted
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      validator: FullNameValidator.validate,
      style: FormStyles.inputTextStyle,
      decoration: InputDecoration(
        hintText: 'Full Name',
        hintStyle: FormStyles.hintStyle,
        prefixIcon: const Icon(Icons.person_outline, color: FormStyles.iconColor, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: FormStyles.contentPadding,
        enabledBorder: FormStyles.enabledBorder,
        focusedBorder: FormStyles.focusedBorder,
        errorBorder: FormStyles.errorBorder,
        focusedErrorBorder: FormStyles.errorBorder,
      ),
    );
  }
}