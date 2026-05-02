class ChatMessage {
  final String text;
  final bool isUser;
  final String timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}