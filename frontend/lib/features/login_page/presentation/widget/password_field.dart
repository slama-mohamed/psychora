import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> _obscureTextNotifier = ValueNotifier<bool>(true);

  PasswordField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [       
        
        
        // TextFormField with ValueListenableBuilder
        ValueListenableBuilder<bool>(
          valueListenable: _obscureTextNotifier,
          builder: (context, obscureText, child) {
            return TextFormField(
              controller: controller,
              obscureText: obscureText,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1F2937),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: '••••••••',
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 15,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16, right: 12),
                  child: Icon(
                    Icons.lock_outline,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 48,
                  minHeight: 20,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF9CA3AF),
                    size: 20,
                  ),
                  onPressed: () {
                    _obscureTextNotifier.value = !_obscureTextNotifier.value;
                  },
                  padding: const EdgeInsets.only(right: 12),
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF3D9970),
                    width: 1,
                  ),
                ),
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
          },
        ),
      ],
    );
  }
}