import 'package:flutter/foundation.dart';
import 'package:psychora/features/patient_dashboard/data/patient_note_model.dart';
import 'dart:math';

class PatientNotesStore {
  PatientNotesStore._internal()
      : notesNotifier = ValueNotifier<List<PatientNoteModel>>(
          <PatientNoteModel>[],
        );

  static final PatientNotesStore _instance = PatientNotesStore._internal();

  factory PatientNotesStore() => _instance;

  final ValueNotifier<List<PatientNoteModel>> notesNotifier;

  List<PatientNoteModel> get currentNotes =>
      List<PatientNoteModel>.of(notesNotifier.value);

  String getNote(String patientId) {
    try {
      return notesNotifier.value
          .firstWhere((PatientNoteModel note) => note.patientId == patientId)
          .note;
    } catch (_) {
      return '';
    }
  }

  void setNotes(List<PatientNoteModel> notes) {
    notesNotifier.value = List<PatientNoteModel>.of(notes)
      ..sort((PatientNoteModel a, PatientNoteModel b) {
        return b.updatedAt.compareTo(a.updatedAt);
      });
  }

  void saveNote({
    required String patientId,
    required String patientName,
    required String note,
  }) {
    final String normalized = note.trim();
    final List<PatientNoteModel> updated = currentNotes;
    updated.removeWhere((PatientNoteModel item) => item.patientId == patientId);

    if (normalized.isEmpty) {
      notesNotifier.value = updated;
      return;
    }

    updated.insert(
      0,
      PatientNoteModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}',
        patientId: patientId,
        patientName: patientName,
        note: normalized,
        updatedAt: DateTime.now(),
      ),
    );

    notesNotifier.value = updated;
  }

  void clearAll() {
    notesNotifier.value = <PatientNoteModel>[];
  }
}
