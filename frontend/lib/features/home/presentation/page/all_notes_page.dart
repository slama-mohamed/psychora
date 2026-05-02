import 'package:flutter/material.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/patient_dashboard/data/patient_note_model.dart';
import 'package:psychora/features/patient_dashboard/data/patient_notes_store.dart';

class AllNotesPage extends StatefulWidget {
  const AllNotesPage({super.key});

  @override
  State<AllNotesPage> createState() => _AllNotesPageState();
}

class _AllNotesPageState extends State<AllNotesPage> {
  final ApiService _apiService = ApiService();
  final PatientNotesStore _notesStore = PatientNotesStore();
  bool _isLoading = false;
  String? _deletingNoteId;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<PatientNoteModel> notes = await _apiService.getPatientNotes();
      final Map<String, String> namesByPatientId = <String, String>{};

      try {
        final patients = await _apiService.getPatients();
        for (final patient in patients) {
          final String id = patient.id.trim();
          final String name = patient.name.trim();
          if (id.isNotEmpty && name.isNotEmpty) {
            namesByPatientId[id] = name;
          }
        }
      } catch (_) {
        // Keep note payload names when patient lookup is unavailable.
      }

      final List<PatientNoteModel> enrichedNotes = notes
          .map((PatientNoteModel note) {
            final String id = note.patientId.trim();
            final String localName = note.patientName.trim();
            final String resolvedName =
                localName.isNotEmpty ? localName : (namesByPatientId[id] ?? '');

            if (resolvedName == note.patientName) {
              return note;
            }

            return note.copyWith(patientName: resolvedName);
          })
          .toList();

      if (!mounted) {
        return;
      }
      _notesStore.setNotes(enrichedNotes);
    } catch (_) {
      if (!mounted) {
        return;
      }

      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        const SnackBar(
          content: Text('Unable to load all notes.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deletePatientNote(PatientNoteModel note) async {
    final String noteId = note.id.trim();
    if (noteId.isEmpty) {
      return;
    }

    setState(() {
      _deletingNoteId = noteId;
    });

    try {
      await _apiService.deletePatientNote(patientId: note.patientId, noteId: noteId);

      final List<PatientNoteModel> updated = _notesStore.currentNotes
          .where((PatientNoteModel item) => item.id != noteId)
          .toList();
      _notesStore.setNotes(updated);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note deleted.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      final String details = _extractErrorMessage(error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to delete: $details'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _deletingNoteId = null;
        });
      }
    }
  }

  Future<void> _confirmDelete(PatientNoteModel note) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete note'),
          content: Text(
            'Do you want to delete the note from ${_resolvePatientName(note)}?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deletePatientNote(note);
    }
  }

  String _resolvePatientName(PatientNoteModel note) {
    final String resolved = note.patientName.trim();
    if (resolved.isNotEmpty) {
      return resolved;
    }
    return 'Unnamed patient';
  }

  String _extractErrorMessage(Object error) {
    final String raw = error.toString().trim();
    if (raw.isEmpty) {
      return 'unknown error';
    }

    const String prefix = 'Exception: ';
    if (raw.startsWith(prefix) && raw.length > prefix.length) {
      return raw.substring(prefix.length);
    }

    return raw;
  }

  List<_PatientNotesGroup> _groupNotesByPatient(List<PatientNoteModel> notes) {
    final Map<String, List<PatientNoteModel>> grouped = <String, List<PatientNoteModel>>{};
    final Map<String, String> namesByKey = <String, String>{};

    for (final PatientNoteModel note in notes) {
      final String id = note.patientId.trim();
      final String name = note.patientName.trim();
      final String key = id.isNotEmpty ? id : name.toLowerCase();
      if (key.isEmpty) {
        continue;
      }

      grouped.putIfAbsent(key, () => <PatientNoteModel>[]).add(note);

      if (!namesByKey.containsKey(key) || namesByKey[key]!.trim().isEmpty) {
        namesByKey[key] = name;
      }
    }

    final List<_PatientNotesGroup> groups = grouped.entries
        .map((MapEntry<String, List<PatientNoteModel>> entry) {
          final List<PatientNoteModel> items = List<PatientNoteModel>.of(entry.value)
            ..sort((PatientNoteModel a, PatientNoteModel b) {
              return b.updatedAt.compareTo(a.updatedAt);
            });

          return _PatientNotesGroup(
            key: entry.key,
            patientName: (namesByKey[entry.key] ?? '').trim().isEmpty
                ? 'Patient sans nom'
                : namesByKey[entry.key]!.trim(),
            notes: items,
          );
        })
        .toList()
      ..sort((
        _PatientNotesGroup a,
        _PatientNotesGroup b,
      ) {
        final DateTime aDate =
            a.notes.isEmpty ? DateTime.fromMillisecondsSinceEpoch(0) : a.notes.first.updatedAt;
        final DateTime bDate =
            b.notes.isEmpty ? DateTime.fromMillisecondsSinceEpoch(0) : b.notes.first.updatedAt;
        return bDate.compareTo(aDate);
      });

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'All Notes',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
        actions: <Widget>[
          IconButton(
            onPressed: _isLoading ? null : _loadNotes,
            tooltip: 'Refresh',
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ValueListenableBuilder<List<PatientNoteModel>>(
            valueListenable: _notesStore.notesNotifier,
            builder: (context, notes, _) {
              if (notes.isEmpty) {
                return Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Text(
                      'No patient notes available.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }

              final List<_PatientNotesGroup> groups = _groupNotesByPatient(notes);

              if (groups.isEmpty) {
                return Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Text(
                      'No patient notes available.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final _PatientNotesGroup group = groups[index];
                  return _PatientNotesBlock(
                    group: group,
                    deletingNoteId: _deletingNoteId,
                    onDeleteRequested: _confirmDelete,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PatientNotesGroup {
  const _PatientNotesGroup({
    required this.key,
    required this.patientName,
    required this.notes,
  });

  final String key;
  final String patientName;
  final List<PatientNoteModel> notes;
}

class _PatientNotesBlock extends StatelessWidget {
  const _PatientNotesBlock({
    required this.group,
    required this.deletingNoteId,
    required this.onDeleteRequested,
  });

  final _PatientNotesGroup group;
  final String? deletingNoteId;
  final Future<void> Function(PatientNoteModel note) onDeleteRequested;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE7DA)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0E000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  size: 16,
                  color: Color(0xFFB45309),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.patientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${group.notes.length} note${group.notes.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...group.notes.map((PatientNoteModel note) {
            final bool isDeleteingThisNote = deletingNoteId == note.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          _formatDate(note.updatedAt),
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: isDeleteingThisNote
                              ? null
                              : () {
                                  onDeleteRequested(note);
                                },
                          icon: isDeleteingThisNote
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(
                                  Icons.delete_outline,
                                  color: Color(0xFFDC2626),
                                  size: 18,
                                ),
                          tooltip: 'Delete note',
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note.note,
                      style: const TextStyle(
                        color: Color(0xFF374151),
                        fontSize: 13.5,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (group.notes.isNotEmpty) const SizedBox(height: 2),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
