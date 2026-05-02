import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/features/home/presentation/widget/add_patient_dialog.dart';
import 'package:psychora/features/patients/domain/models/patient.dart';
import 'package:psychora/features/patient_dashboard/data/patient_notes_store.dart';
import 'package:psychora/features/patients/presentation/providers/patient_provider.dart';
import 'package:psychora/features/patient_dashboard/presentation/widget/barre_de_recherche.dart';
import 'package:psychora/features/patient_dashboard/presentation/widget/header_text.dart';
import 'package:psychora/features/patient_dashboard/presentation/widget/patient_card.dart';



class Patientdashboardform extends StatefulWidget {
  const Patientdashboardform({super.key});

  @override
  State<Patientdashboardform> createState() => _PatientdashboardformState();
}

class _PatientdashboardformState extends State<Patientdashboardform> {
  late TextEditingController _searchController;
  final PatientNotesStore _patientNotesStore = PatientNotesStore();
  late List<Patient> _allPatients;
  late List<Patient> _filteredPatients;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _allPatients = <Patient>[];
    _filteredPatients = <Patient>[];
    _searchController.addListener(_filterPatients);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final PatientProvider provider = context.read<PatientProvider>();
      provider.addListener(_handlePatientsChanged);
      if (!mounted) return;
      setState(() {
        _allPatients = provider.patients;
        _filteredPatients = provider.patients;
      });
      if (_allPatients.isEmpty) {
        provider.syncFromBackend();
      }
    });
  }

  void _handlePatientsChanged() {
    if (!mounted) {
      return;
    }

    final PatientProvider provider = context.read<PatientProvider>();
    setState(() {
      _allPatients = provider.patients;
      _filterPatients();
    });
  }

  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients = _allPatients.where((patient) {
        return patient.name.toLowerCase().contains(query) ||
            patient.id.toLowerCase().contains(query) ||
            patient.condition.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _confirmAndDeletePatient(Patient patient) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete patient'),
          content: Text('Remove ${patient.name} from the patient list?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
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

    if (shouldDelete != true) {
      return;
    }

    try {
      await context.read<PatientProvider>().deletePatient(patient.id);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete ${patient.name}.'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Patient deleted: ${patient.name}'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmAndUpdatePatient(Patient patient) async {
    final Patient? updatedPatient = await showDialog<Patient>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AddPatientDialog(initialPatient: patient),
    );

    if (updatedPatient == null) {
      return;
    }

    try {
      await context.read<PatientProvider>().updatePatient(updatedPatient.copyWith(id: patient.id));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update ${patient.name}.'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Patient updated: ${updatedPatient.name}'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openPatientNotesEditor(Patient patient) async {
    final String patientId = patient.id.trim();
    final String patientName = patient.name.trim();

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
  void dispose() {
    _searchController.dispose();
    context.read<PatientProvider>().removeListener(_handlePatientsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          // Header
          HeaderText(filteredPatients: _filteredPatients),

          // Barre de recherche
          BarreDeRecherche(
            controller: _searchController,
            onChanged: (_) {
              _filterPatients();
            },
          ),

          // Liste des patients
          Expanded(
            child: _filteredPatients.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_search_rounded,
                            size: 56,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _searchController.text.isEmpty
                              ? 'No patients available'
                              : 'No patients found',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Start adding patients'
                              : 'Try another search',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: _filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = _filteredPatients[index];
                      return PatientCard(
                        patientName: patient.name,
                        patientId: patient.id,
                        age: patient.age,
                        condition: patient.condition,
                        nextVisit: patient.nextVisit,
                        sessionsCount: patient.sessionsCount,
                        onContinueChat: () {
                          context.pushNamed(
                            RouteName.chatbotinterface,
                            extra: <String, dynamic>{
                              'patientId': patient.id,
                              'patientName': patient.name,
                            },
                          );
                        },
                        onEdit: () {
                          _confirmAndUpdatePatient(patient);
                        },
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Profile: ${patient.name}',
                              ),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        onDelete: () {
                          _confirmAndDeletePatient(patient);
                        },
                        onSummary: () {
                          _openPatientNotesEditor(patient);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}