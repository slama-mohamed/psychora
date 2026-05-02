import 'package:flutter/material.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/patient_dashboard/data/patient_note_model.dart';
import 'package:psychora/features/patient_dashboard/data/patient_notes_store.dart';

class AllNotesSection extends StatefulWidget {
  const AllNotesSection({super.key});

  @override
  State<AllNotesSection> createState() => _AllNotesSectionState();
}

class _AllNotesSectionState extends State<AllNotesSection> {
  final ApiService _apiService = ApiService();
  final PatientNotesStore _notesStore = PatientNotesStore();
  bool _isLoading = false;

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
      if (!mounted) {
        return;
      }
      _notesStore.setNotes(notes);
    } catch (_) {
      if (!mounted) {
        return;
      }
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        const SnackBar(
          content: Text('Unable to load notes from the database.'),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFFFF8EE),
            Color(0xFFFFF2DD),
          ],
        ),
        border: Border.all(color: const Color(0xFFFBD8A5)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12F59E0B),
            blurRadius: 18,
            offset: Offset(0, 9),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.note_alt_rounded,
                  size: 18,
                  color: Color(0xFFB45309),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'All Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              IconButton(
                onPressed: _isLoading ? null : _loadNotes,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh_rounded),
                color: const Color(0xFFB45309),
                tooltip: 'Refresh notes',
              ),
            ],
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<List<PatientNoteModel>>(
            valueListenable: _notesStore.notesNotifier,
            builder: (context, notes, _) {
              if (notes.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF3E3C6)),
                  ),
                  child: const Text(
                    'No notes available right now.',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              final List<PatientNoteModel> displayed = notes.take(5).toList();

              return Column(
                children: displayed.map((PatientNoteModel note) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _NoteCard(note: note),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final PatientNoteModel note;

  @override
  Widget build(BuildContext context) {
    final String title = note.patientName.trim().isEmpty
        ? 'Patient ${note.patientId}'
        : note.patientName;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3E3C6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.person_outline_rounded,
                size: 16,
                color: Color(0xFF92400E),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Text(
                _formatDate(note.updatedAt),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.note,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.35,
              color: Color(0xFF4B5563),
              fontWeight: FontWeight.w500,
            ),
          ),
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
