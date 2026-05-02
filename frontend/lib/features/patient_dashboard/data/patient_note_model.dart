class PatientNoteModel {
  final String id;
  final String patientId;
  final String patientName;
  final String note;
  final DateTime updatedAt;

  const PatientNoteModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.note,
    required this.updatedAt,
  });

  factory PatientNoteModel.fromMap(Map<String, dynamic> map) {
    final dynamic nestedPatient = map['patient'];

    final String id = (map['id'] ?? map['_id'] ?? map['noteId'] ?? '').toString();
    
    final String patientId = (map['patientId'] ??
        map['patient_id'] ??
        map['idPatient'] ??
        (nestedPatient is Map<String, dynamic>
          ? (nestedPatient['id'] ?? nestedPatient['_id'] ?? nestedPatient['patientId'])
          : null) ??
        '')
      .toString();
    final String patientName = (map['patientName'] ??
        map['patient_name'] ??
        map['fullName'] ??
        map['name'] ??
        (nestedPatient is Map<String, dynamic>
          ? (nestedPatient['fullName'] ?? nestedPatient['name'])
          : null) ??
        '')
      .toString();
    final String note = (map['note'] ?? map['content'] ?? map['text'] ?? '').toString();

    final dynamic dateValue = map['updatedAt'] ?? map['updated_at'] ?? map['createdAt'];
    DateTime updatedAt = DateTime.now();
    if (dateValue is String) {
      updatedAt = DateTime.tryParse(dateValue) ?? DateTime.now();
    }

    return PatientNoteModel(
      id: id,
      patientId: patientId,
      patientName: patientName,
      note: note,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'note': note,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PatientNoteModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? note,
    DateTime? updatedAt,
  }) {
    return PatientNoteModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
