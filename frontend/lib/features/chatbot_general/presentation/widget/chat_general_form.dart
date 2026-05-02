import 'package:flutter/material.dart';
import 'package:psychora/features/chatbot_general/presentation/function/chat_general_services.dart';
import 'package:psychora/features/chatbot_general/presentation/widget/chat_general_input_area.dart';
import 'package:psychora/features/chatbot_general/presentation/widget/chat_general_message.dart';
import 'package:psychora/features/chatbot_general/presentation/widget/chat_general_message_bubble.dart';

class ChatGeneralForm extends StatefulWidget {
  const ChatGeneralForm({super.key});

  @override
  State<ChatGeneralForm> createState() => _ChatGeneralFormState();
}

class _ChatGeneralFormState extends State<ChatGeneralForm> {
  late final TextEditingController _messageController;
  late final ChatGeneralServices _chatServices;
  final List<ChatGeneralMessage> messages = [];
  bool _isSending = false;
  bool _isLoadingHistory = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _chatServices = ChatGeneralServices();
    _loadHistory();
  }

  /// Charge l'historique de la conversation depuis le backend
  Future<void> _loadHistory() async {
    setState(() => _isLoadingHistory = true);

    try {
      final List<Map<String, dynamic>> history =
          await _chatServices.getStudentMessages();

      if (!mounted) return;

      if (history.isEmpty) {
        _addWelcomeMessage();
      } else {
        setState(() {
          messages.clear();
          for (final Map<String, dynamic> msg in history) {
            final String role = (msg['role'] ?? '').toString();
            final String content =
                (msg['content'] ?? msg['message'] ?? '').toString();
            if (content.isNotEmpty) {
              messages.add(ChatGeneralMessage(
                text: content,
                isUser: role == 'user',
                timestamp: (msg['timestamp'] ?? '').toString(),
              ));
            }
          }
        });
      }
    } catch (_) {
      if (mounted) _addWelcomeMessage();
    } finally {
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }

  void _addWelcomeMessage() {
    setState(() {
      if (messages.isEmpty) {
        messages.add(const ChatGeneralMessage(
          text:
              'Hello! I am Psychora, your mental health assistant. How can I help you today?',
          isUser: false,
          timestamp: 'Just now',
        ));
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_isSending) return;

    final String userText = _messageController.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      messages.add(
        ChatGeneralMessage(
          text: userText,
          isUser: true,
          timestamp: getCurrentTime(),
        ),
      );
      _messageController.clear();
      _isSending = true;
    });

    try {
      final String botReply = await _chatServices.sendStudentMessage(
        userMessage: userText,
        history: _buildHistory(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        messages.add(
          ChatGeneralMessage(
            text: botReply,
            isUser: false,
            timestamp: getCurrentTime(),
          ),
        );
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        messages.add(
          ChatGeneralMessage(
            text: 'Unable to reach the chatbot right now. Detail: $error',
            isUser: false,
            timestamp: getCurrentTime(),
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _buildHistory() {
    return messages
        .map(
          (ChatGeneralMessage message) => <String, dynamic>{
            'role': message.isUser ? 'user' : 'assistant',
            'content': message.text,
            'timestamp': message.timestamp,
          },
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _isLoadingHistory
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    return ChatGeneralMessageBubble(message: message);
                  },
                ),
        ),
        const SizedBox(height: 16),
        ChatGeneralInputArea(
          controller: _messageController,
          onSend: _sendMessage,
          enabled: !_isSending && !_isLoadingHistory,
          isLoading: _isSending,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
