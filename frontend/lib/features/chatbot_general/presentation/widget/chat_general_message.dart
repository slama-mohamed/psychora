class ChatGeneralMessage {
  final String text;
  final bool isUser;
  final String timestamp;

  const ChatGeneralMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
