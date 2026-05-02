import 'package:flutter/material.dart';

class ChatGeneralInputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;
  final bool isLoading;

  const ChatGeneralInputArea({
    super.key,
    required this.controller,
    required this.onSend,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefixIcon: Icon(
                  Icons.mail_outline,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ),
              style: const TextStyle(color: Color(0xFF1F2937), fontSize: 14),
              maxLines: null,
              onSubmitted: enabled ? (_) => onSend() : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: enabled ? onSend : null,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF3D9970),
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: Color(0xFF3D9970),
                      size: 20,
                    ),
              tooltip: 'Send',
            ),
          ),
        ],
      ),
    );
  }
}
