import 'package:flutter/material.dart';
import 'package:psychora/core/styles/form_styles.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: FormStyles.labelStyle),
        const SizedBox(height: 7),
        child,
      ],
    );
  }
}
