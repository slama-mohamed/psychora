import 'package:flutter/material.dart';
import 'package:psychora/core/styles/form_styles.dart';

/// Widget réutilisable pour champ de formulaire profession
class ProfessionalInputField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? iconColor;

  const ProfessionalInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.textStyle,
    this.hintStyle,
    this.iconColor,
  });

  @override
  State<ProfessionalInputField> createState() => _ProfessionalInputFieldState();
}

class _ProfessionalInputFieldState extends State<ProfessionalInputField> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: widget.textStyle ?? const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          onChanged: widget.onChanged,
          autovalidateMode: _hasInteracted
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          style: widget.textStyle ?? FormStyles.inputTextStyle,
          decoration: FormStyles.baseDecoration(icon: widget.icon, hint: widget.hint).copyWith(
            hintStyle: widget.hintStyle ?? FormStyles.hintStyle,
            prefixIcon: Icon(widget.icon, color: widget.iconColor ?? FormStyles.iconColor, size: 20),
            errorBorder: FormStyles.errorBorder,
            focusedErrorBorder: FormStyles.errorBorder,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
