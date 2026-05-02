class PatientModel {
  final String id;
  final String name;
  final int age;
  final String condition;
  final String lastSeen;
  final int sessionsCount;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.condition,
    required this.lastSeen,
    required this.sessionsCount,
  });

  PatientModel copyWith({
    String? id,
    String? name,
    int? age,
    String? condition,
    String? lastSeen,
    int? sessionsCount,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      condition: condition ?? this.condition,
      lastSeen: lastSeen ?? this.lastSeen,
      sessionsCount: sessionsCount ?? this.sessionsCount,
    );
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: _readString(map, <String>['id', '_id', 'patientId']),
      name: _readString(map, <String>['name', 'fullName', 'patientName']),
      age: _readInt(map, <String>['age']),
      condition: _normalizeCondition(_readString(map, <String>['condition', 'diagnosis', 'state'])),
      lastSeen: _readString(map, <String>['lastSeen', 'lastVisit', 'lastseen', 'nextVisit', 'next_visit', 'visitDate', 'visit_date']),
      sessionsCount: _readInt(map, <String>['sessionsCount', 'sessions']),
    );
  }

  static String _readString(Map<String, dynamic> map, List<String> keys) {
    for (final String key in keys) {
      final dynamic value = map[key];
      if (value == null) {
        continue;
      }
      final String normalized = value.toString().trim();
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }
    return '';
  }

  static int _readInt(Map<String, dynamic> map, List<String> keys) {
    for (final String key in keys) {
      final dynamic value = map[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        final int? parsed = int.tryParse(value.trim());
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return 0;
  }

  static String _normalizeCondition(String condition) {
    if (condition.trim().isEmpty) {
      return 'Diagnosis not yet established';
    }
    return condition;
  }
}