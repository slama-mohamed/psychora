import 'package:flutter/material.dart';

class FormStyles {
  // Label style (small uppercase labels)
  static const TextStyle labelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Color(0xFF374151),
    letterSpacing: 0.3,
  );

  // Input text style
  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 15,
    color: Color(0xFF1F2937),
    fontWeight: FontWeight.w500,
  );

  // Hint style
  static const TextStyle hintStyle = TextStyle(
    color: Color(0xFFD1D5DB),
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  // Icon color
  static const Color iconColor = Color(0xFF9CA3AF);

  // Borders and paddings
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(10));
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 16);

  static const OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
  );

  static const OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: Color(0xFF3D9970), width: 1.5),
  );

  static const OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: Color(0xFFEF4444), width: 1.2),
  );

  static InputDecoration baseDecoration({IconData? icon, String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: hintStyle,
      prefixIcon: icon != null ? Icon(icon, color: iconColor, size: 20) : null,
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding: contentPadding,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      errorMaxLines: 1,
    );
  }
}
