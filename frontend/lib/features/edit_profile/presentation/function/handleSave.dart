
import 'package:flutter/material.dart';

bool handleSave(
  BuildContext context,
  GlobalKey<FormState> formKey, {
  String successMessage = 'Profile updated successfully',
}) {
  if (formKey.currentState?.validate() ?? false) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successMessage),
        backgroundColor: const Color(0xFF2D7A5C),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return true;
  }

  return false;
}