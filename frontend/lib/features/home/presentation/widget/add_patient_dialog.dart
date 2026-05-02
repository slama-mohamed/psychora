import 'package:flutter/material.dart';
import 'package:psychora/features/patients/domain/models/patient.dart';

class AddPatientDialog extends StatefulWidget {
  final Patient? initialPatient;

  const AddPatientDialog({super.key, this.initialPatient});

  bool get isEditing => initialPatient != null;

  @override
  State<AddPatientDialog> createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<AddPatientDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _conditionController;
  late final TextEditingController _nextVisitController;
  late final TextEditingController _sessionsController;
  DateTime? _selectedNextVisit;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final Patient? patient = widget.initialPatient;
    _selectedNextVisit = patient?.nextVisit != null && patient!.nextVisit!.trim().isNotEmpty
        ? DateTime.tryParse(patient.nextVisit!)
        : null;
    _nameController = TextEditingController(text: patient?.name ?? '');
    _ageController = TextEditingController(text: patient?.age.toString() ?? '');
    _conditionController = TextEditingController(
      text: patient?.condition ?? 'Diagnosis not yet established',
    );
    _nextVisitController = TextEditingController(text: _formatNextVisitDisplay(_selectedNextVisit));
    _sessionsController = TextEditingController(text: patient?.sessionsCount.toString() ?? '0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _conditionController.dispose();
    _nextVisitController.dispose();
    _sessionsController.dispose();
    super.dispose();
  }

  String _formatNextVisitDisplay(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    final String day = dateTime.day.toString().padLeft(2, '0');
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String year = dateTime.year.toString().substring(2);
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year à ${hour}h$minute';
  }

  Future<void> _selectNextVisit() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _selectedNextVisit ?? now;
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );

    if (selectedDate == null) {
      return;
    }

    final TimeOfDay initialTime = _selectedNextVisit != null
        ? TimeOfDay(hour: _selectedNextVisit!.hour, minute: _selectedNextVisit!.minute)
        : const TimeOfDay(hour: 9, minute: 0);

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime == null) {
      return;
    }

    setState(() {
      _selectedNextVisit = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      _nextVisitController.text = _formatNextVisitDisplay(_selectedNextVisit);
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final int? parsedAge = int.tryParse(_ageController.text.trim());
    if (parsedAge == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final String conditionValue = _conditionController.text.trim().isEmpty
        ? 'Diagnosis not yet established'
        : _conditionController.text.trim();

    final Patient patient = Patient(
      id: widget.initialPatient?.id ?? '',
      name: _nameController.text.trim(),
      age: parsedAge,
      condition: conditionValue,
      nextVisit: _selectedNextVisit?.toIso8601String(),
      sessionsCount: int.tryParse(_sessionsController.text.trim()) ?? 0,
    );

    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditing ? 'Patient mis à jour : ${patient.name}' : 'Patient ajouté : ${patient.name}',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      ),
    );

    Navigator.of(context).pop(patient);
  }

  InputDecoration _fieldDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      title: Row(
        children: [
          Icon(
            widget.isEditing ? Icons.edit_note_rounded : Icons.person_add_alt_1_rounded,
            color: const Color(0xFF1F2937),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.isEditing ? 'Update Patient' : 'Add New Patient',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _fieldDecoration('Full name', 'Ex: Sara El Moussa'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                decoration: _fieldDecoration('Age', 'Ex: 29'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Age is required';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _conditionController,
                decoration: _fieldDecoration('Diagnosis / condition', 'Diagnosis not yet established'),
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nextVisitController,
                readOnly: true,
                onTap: _selectNextVisit,
                decoration: _fieldDecoration('Next visit', 'Select a date and time'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sessionsController,
                decoration: _fieldDecoration('Sessions count', 'Ex: 8'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Sessions count is required';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Exit', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3D9970),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(100, 40),
          ),
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  widget.isEditing ? 'Update' : 'Add',
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }
}
