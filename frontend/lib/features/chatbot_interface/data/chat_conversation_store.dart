class ChatConversationStore {
  ChatConversationStore._internal();

  static final ChatConversationStore _instance = ChatConversationStore._internal();

  factory ChatConversationStore() => _instance;

  final Map<String, List<Map<String, dynamic>>> _conversationsByPatient =
      <String, List<Map<String, dynamic>>>{};
  final Map<String, List<Map<String, dynamic>>> _savedConversationsByPatient =
      <String, List<Map<String, dynamic>>>{};

  List<Map<String, dynamic>> getConversation(String key) {
    final List<Map<String, dynamic>>? existing = _conversationsByPatient[key];
    if (existing == null) {
      return <Map<String, dynamic>>[];
    }
    return existing
        .map((Map<String, dynamic> message) => Map<String, dynamic>.of(message))
        .toList();
  }

  void saveConversation(String key, List<Map<String, dynamic>> messages) {
    _conversationsByPatient[key] = messages
        .map((Map<String, dynamic> message) => Map<String, dynamic>.of(message))
        .toList();
  }

  void clearConversation(String key) {
    _conversationsByPatient.remove(key);
  }

  String saveConversationSnapshot(
    String key,
    List<Map<String, dynamic>> messages,
    {
    String? backendConversationId,
    String? patientId,
    String? title,
    String? updatedAt,
  }
  ) {
    final List<Map<String, dynamic>> normalizedMessages = messages
        .map((Map<String, dynamic> message) => Map<String, dynamic>.of(message))
        .toList();
    if (normalizedMessages.isEmpty) {
      return '';
    }

    final String id = DateTime.now().microsecondsSinceEpoch.toString();
    final DateTime now = DateTime.now();

    final String resolvedTitle =
        (title ?? '').trim().isNotEmpty ? title!.trim() : _buildConversationTitle(normalizedMessages);
    final String resolvedUpdatedAt =
        (updatedAt ?? '').trim().isNotEmpty ? updatedAt!.trim() : now.toIso8601String();
    final String resolvedPatientId = (patientId ?? '').trim();
    final String resolvedBackendConversationId = (backendConversationId ?? '').trim();

    final Map<String, dynamic> snapshot = <String, dynamic>{
      'id': id,
      'title': resolvedTitle,
      'updatedAt': resolvedUpdatedAt,
      'patientId': resolvedPatientId,
      'backendConversationId': resolvedBackendConversationId,
      'messages': normalizedMessages,
    };

    final List<Map<String, dynamic>> existing =
        _savedConversationsByPatient[key] ?? <Map<String, dynamic>>[];
    _savedConversationsByPatient[key] = <Map<String, dynamic>>[
      snapshot,
      ...existing.where(
        (Map<String, dynamic> item) => _sameMessages(item['messages'], normalizedMessages) == false,
      ),
    ];

    return id;
  }

  Map<String, dynamic>? getSavedConversation(String key, String id) {
    final List<Map<String, dynamic>> existing =
        _savedConversationsByPatient[key] ?? <Map<String, dynamic>>[];

    for (final Map<String, dynamic> item in existing) {
      if ((item['id'] ?? '').toString() == id) {
        return Map<String, dynamic>.of(item);
      }
    }

    return null;
  }

  List<Map<String, dynamic>> getSavedConversations(String key) {
    final List<Map<String, dynamic>> existing =
        _savedConversationsByPatient[key] ?? <Map<String, dynamic>>[];
    return existing
        .map((Map<String, dynamic> item) => Map<String, dynamic>.of(item))
        .toList();
  }

  List<Map<String, dynamic>> getSavedConversationMessages(String key, String id) {
    final List<Map<String, dynamic>> existing =
        _savedConversationsByPatient[key] ?? <Map<String, dynamic>>[];

    final Map<String, dynamic>? found = existing.cast<Map<String, dynamic>?>().firstWhere(
      (Map<String, dynamic>? item) => (item?['id'] ?? '').toString() == id,
      orElse: () => null,
    );

    if (found == null) {
      return <Map<String, dynamic>>[];
    }

    final dynamic payload = found['messages'];
    if (payload is! List) {
      return <Map<String, dynamic>>[];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> message) => Map<String, dynamic>.of(message))
        .toList();
  }

  void deleteSavedConversation(String key, String id) {
    final List<Map<String, dynamic>> existing =
        _savedConversationsByPatient[key] ?? <Map<String, dynamic>>[];
    _savedConversationsByPatient[key] = existing
        .where((Map<String, dynamic> item) => (item['id'] ?? '').toString() != id)
        .map((Map<String, dynamic> item) => Map<String, dynamic>.of(item))
        .toList();
  }

  String _buildConversationTitle(List<Map<String, dynamic>> messages) {
    final Map<String, dynamic>? firstUserMessage = messages.cast<Map<String, dynamic>?>().firstWhere(
      (Map<String, dynamic>? message) => (message?['role'] ?? '').toString() == 'user',
      orElse: () => null,
    );

    final String content = (firstUserMessage?['content'] ?? '').toString().trim();
    if (content.isEmpty) {
      return 'Untitled conversation';
    }

    if (content.length <= 40) {
      return content;
    }

    return '${content.substring(0, 40)}...';
  }

  bool _sameMessages(dynamic left, List<Map<String, dynamic>> right) {
    if (left is! List || left.length != right.length) {
      return false;
    }

    for (int i = 0; i < right.length; i++) {
      final dynamic leftEntry = left[i];
      final Map<String, dynamic> rightEntry = right[i];
      if (leftEntry is! Map<String, dynamic>) {
        return false;
      }

      if ((leftEntry['role'] ?? '').toString() != (rightEntry['role'] ?? '').toString()) {
        return false;
      }

      if ((leftEntry['content'] ?? '').toString() != (rightEntry['content'] ?? '').toString()) {
        return false;
      }
    }

    return true;
  }

  void clearAll() {
    _conversationsByPatient.clear();
    _savedConversationsByPatient.clear();
  }
}
