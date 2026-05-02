import 'package:flutter/material.dart';
import 'package:psychora/features/chatbot_interface/presentation/function/chatservices.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/chatmessage.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/inputarea.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/messagebubble.dart';

class ChatinterfaceForm extends StatefulWidget {
  final String? patientId;
  final String? patientName;

  const ChatinterfaceForm({
    super.key,
    this.patientId,
    this.patientName,
  });

  @override
  State<ChatinterfaceForm> createState() => _ChatinterfaceFormState();
}

class _ChatinterfaceFormState extends State<ChatinterfaceForm> {
  late final TextEditingController _messageController;
  late final ChatServices _chatServices;
  final List<ChatMessage> messages = [];
  bool _isSending = false;
  bool _isLoadingHistory = false;

  String get _welcomeText {
    if (widget.patientName != null && widget.patientName!.trim().isNotEmpty) {
      return 'Hello! Conversation resumed with ${widget.patientName!.trim()}. How can I help you today?';
    }
    return 'Hello! I am Psychora, your mental health assistant. How can I help you today?';
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _chatServices = ChatServices();
    _loadHistory();
  }

  /// Charge l'historique depuis le backend au démarrage
  Future<void> _loadHistory() async {
    final String patientId = (widget.patientId ?? '').trim();
    if (patientId.isEmpty) {
      _addWelcomeMessage();
      return;
    }

    setState(() => _isLoadingHistory = true);

    try {
      final List<Map<String, dynamic>> history =
          await _chatServices.loadConversation(patientId: patientId);

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
              messages.add(ChatMessage(
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
        messages.add(ChatMessage(
          text: _welcomeText,
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
        ChatMessage(
          text: userText,
          isUser: true,
          timestamp: getCurrentTime(),
        ),
      );
      _messageController.clear();
      _isSending = true;
    });

    final String activePatientId = (widget.patientId ?? '').trim();
    if (activePatientId.isEmpty) {
      setState(() {
        messages.add(
          ChatMessage(
            text: 'Impossible to reach the chatbot: unidentified patient.',
            isUser: false,
            timestamp: getCurrentTime(),
          ),
        );
        _isSending = false;
      });
      return;
    }

    try {
      final String botReply = await _chatServices.sendMessage(
        patientId: activePatientId,
        userMessage: userText,
        history: _buildHistory(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        messages.add(
          ChatMessage(
            text: botReply,
            isUser: false,
            timestamp: getCurrentTime(),
          ),
        );
      });

      // Sauvegarder la conversation sur le backend après chaque réponse
      _chatServices.saveConversation(
        patientId: activePatientId,
        history: _buildHistory(),
      ).catchError((_) {});
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        messages.add(
          ChatMessage(
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
          (ChatMessage message) => <String, dynamic>{
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
        // Messages area
        Expanded(
          child: _isLoadingHistory
              ? const Center(child: CircularProgressIndicator())
              : messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No messages yet',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[messages.length - 1 - index];
                        return MessageBubble(message: message);
                      },
                    ),
        ),
        const SizedBox(height: 16),
        // Input area
        InputArea(
          controller: _messageController,
          onSend: () {
            _sendMessage();
          },
          enabled: !_isSending && !_isLoadingHistory,
          isLoading: _isSending,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
