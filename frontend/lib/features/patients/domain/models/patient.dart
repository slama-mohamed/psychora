import 'dart:convert';

class Patient {
  final String id;
  final String name;
  final int age;
  final String condition;
  final String? nextVisit;
  final int sessionsCount;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.condition,
    this.nextVisit,
    required this.sessionsCount,
  });

  Patient copyWith({
    String? id,
    String? name,
    int? age,
    String? condition,
    String? nextVisit,
    int? sessionsCount,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      condition: condition ?? this.condition,
      nextVisit: nextVisit ?? this.nextVisit,
      sessionsCount: sessionsCount ?? this.sessionsCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'condition': condition,
      'nextVisit': nextVisit,
      'sessionsCount': sessionsCount,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse(json['age']?.toString() ?? '') ?? 0,
      condition: json['condition']?.toString() ?? '',
      nextVisit: json['nextVisit']?.toString().trim().isEmpty == true
          ? null
          : json['nextVisit']?.toString(),
      sessionsCount: json['sessionsCount'] is int
          ? json['sessionsCount'] as int
          : int.tryParse(json['sessionsCount']?.toString() ?? '') ?? 0,
    );
  }

  factory Patient.fromRawJson(String source) =>
      Patient.fromJson(jsonDecode(source) as Map<String, dynamic>);

  String toRawJson() => jsonEncode(toJson());
}
