import 'package:flutter/material.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/chatbot_interface/presentation/function/chatservices.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/chatinterface_form.dart';
import 'package:psychora/features/patient_dashboard/data/patient_notes_store.dart';

class ChatbotInterface extends StatefulWidget {
  final String? patientId;
  final String? patientName;

  const ChatbotInterface({
    super.key,
    this.patientId,
    this.patientName,
  });

  @override
  State<ChatbotInterface> createState() => _ChatbotInterfaceState();
}

class _ChatbotInterfaceState extends State<ChatbotInterface> {
  final ApiService _apiService = ApiService();
  final PatientNotesStore _patientNotesStore = PatientNotesStore();
  final ChatServices _chatServices = ChatServices();

  Future<void> _openPatientNotesEditor() async {
    final String patientId = (widget.patientId ?? '').trim();
    if (patientId.isEmpty) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a patient before writing notes.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final String patientName = (widget.patientName ?? '').trim();
    String draftNote = '';

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          title: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.sticky_note_2_outlined,
                  color: Color(0xFF2F855A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  patientName.isEmpty ? 'Patient notes' : 'Notes - $patientName',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Capture key observations for this patient.',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '',
                onChanged: (String value) {
                  draftNote = value;
                },
                maxLines: 8,
                minLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write notes for this patient...',
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2F855A), width: 1.4),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4B5563),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F855A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (shouldSave == true) {
      final String normalized = draftNote.trim();

      if (normalized.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Write a note before saving.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      try {
        await _apiService.savePatientNote(
          patientId: patientId,
          note: normalized,
        );
      } catch (_) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save patient notes.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      _patientNotesStore.saveNote(
        patientId: patientId,
        patientName: patientName,
        note: normalized,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notes saved.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.patientName == null || widget.patientName!.trim().isEmpty
              ? 'Psychora Chatbot'
              : 'Chat - ${widget.patientName!.trim()}',
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _openPatientNotesEditor();
            },
            tooltip: 'Write patient notes',
            icon: const Icon(
              Icons.note_add_outlined,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ChatinterfaceForm(
            patientId: widget.patientId,
            patientName: widget.patientName,
          ),
        ),
      ),
    );
  }
}