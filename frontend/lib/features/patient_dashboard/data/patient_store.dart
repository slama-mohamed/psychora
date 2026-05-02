import 'package:flutter/foundation.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';

class PatientStore {
  PatientStore._internal()
      : patientsNotifier = ValueNotifier<List<PatientModel>>(
          <PatientModel>[],
        );

  static final PatientStore _instance = PatientStore._internal();

  factory PatientStore() => _instance;

  final ValueNotifier<List<PatientModel>> patientsNotifier;

  List<PatientModel> get currentPatients => List<PatientModel>.of(patientsNotifier.value);

  void setPatients(List<PatientModel> patients) {
    patientsNotifier.value = List<PatientModel>.of(patients);
  }

  void addPatient(PatientModel patient) {
    final List<PatientModel> updatedPatients = <PatientModel>[
      patient,
      ...patientsNotifier.value,
    ];
    patientsNotifier.value = updatedPatients;
  }

  void updatePatient(PatientModel updatedPatient) {
    final List<PatientModel> updatedPatients = patientsNotifier.value
        .map((PatientModel patient) {
          return patient.id == updatedPatient.id ? updatedPatient : patient;
        })
        .toList();
    patientsNotifier.value = updatedPatients;
  }

  void removePatientById(String patientId) {
    final List<PatientModel> updatedPatients = patientsNotifier.value
        .where((PatientModel patient) => patient.id != patientId)
        .toList();
    patientsNotifier.value = updatedPatients;
  }

  void clearAll() {
    patientsNotifier.value = <PatientModel>[];
  }
}
