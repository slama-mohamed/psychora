import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';
import '../../domain/models/patient.dart';

class PatientProvider extends ChangeNotifier {
  static const String _storageKey = 'patients_list';

  final SharedPreferences _preferences;
  final Uuid _uuid = const Uuid();

  List<Patient> _patients = [];

  PatientProvider(this._preferences);

  List<Patient> get patients => List<Patient>.unmodifiable(_patients);

  List<Patient> get todayPatients {
    final DateTime now = DateTime.now();
    return _patients
        .where((Patient patient) {
          if (patient.nextVisit == null || patient.nextVisit!.trim().isEmpty) {
            return false;
          }
          final DateTime? visitDate = DateTime.tryParse(patient.nextVisit!);
          if (visitDate == null) {
            return false;
          }
          return visitDate.year == now.year &&
              visitDate.month == now.month &&
              visitDate.day == now.day;
        })
        .toList()
      ..sort((Patient left, Patient right) {
        final DateTime leftDate = DateTime.parse(left.nextVisit!);
        final DateTime rightDate = DateTime.parse(right.nextVisit!);
        return leftDate.compareTo(rightDate);
      });
  }

  Future<void> load() async {
    final String? raw = _preferences.getString(_storageKey);
    if (raw == null || raw.trim().isEmpty) {
      // If no local data, try to load from backend
      await loadFromBackend();
      return;
    }

    try {
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      _patients = jsonList
          .map((dynamic item) => Patient.fromJson(item as Map<String, dynamic>))
          .toList();
      if (_patients.isEmpty) {
        await loadFromBackend();
        return;
      }
    } catch (_) {
      await loadFromBackend();
      return;
    }

    notifyListeners();
  }

  Future<void> loadFromBackend() async {
    try {
      final ApiService apiService = ApiService();
      final List<PatientModel> backendPatients = await apiService.getPatients();
      _patients = backendPatients.map((PatientModel pm) => Patient(
        id: pm.id,
        name: pm.name,
        age: pm.age,
        condition: pm.condition,
        nextVisit: pm.lastSeen, // Map lastSeen to nextVisit
        sessionsCount: pm.sessionsCount,
      )).toList();
      await _save();
    } catch (e) {
      // If backend fails, keep local data
      debugPrint('Failed to load patients from backend: $e');
      _patients = _patients;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addPatient(Patient patient) async {
    final String generatedId = patient.id.isNotEmpty ? patient.id : generateId();
    Patient savedPatient = patient.copyWith(id: generatedId);
    final String lastSeenValue = patient.nextVisit?.trim().isNotEmpty == true
        ? patient.nextVisit!
        : DateTime.now().toIso8601String();

    debugPrint('Starting addPatient for ${patient.name}');
    try {
      final ApiService apiService = ApiService();
      debugPrint('Calling backend addPatient with lastSeen=$lastSeenValue');
      final response = await apiService.addPatient(
        name: patient.name,
        age: patient.age,
        condition: patient.condition,
        lastSeen: lastSeenValue,
        sessionsCount: patient.sessionsCount,
      );
      debugPrint('addPatient response received: ${response.data}');
      final String? backendId = _extractPatientIdFromResponse(response.data);
      if (backendId != null && backendId.isNotEmpty) {
        savedPatient = savedPatient.copyWith(id: backendId);
        debugPrint('Extracted backend ID: $backendId');
      } else {
        debugPrint('No backend ID extracted');
      }
    } catch (e) {
      debugPrint('Failed to add patient to backend: $e');
      // Continue with local add even if backend fails
    }

    debugPrint('Adding patient locally: ${savedPatient.name}');
    _patients = <Patient>[savedPatient, ..._patients];
    await _save();
    notifyListeners();
    debugPrint('addPatient completed');
  }

  Future<void> updatePatient(Patient patient) async {
    final String lastSeenValue = patient.nextVisit?.trim().isNotEmpty == true
        ? patient.nextVisit!
        : DateTime.now().toIso8601String();

    try {
      final ApiService apiService = ApiService();
      debugPrint('Calling backend updatePatient for id=${patient.id} lastSeen=$lastSeenValue');
      final response = await apiService.updatePatient(
        patientId: patient.id,
        name: patient.name,
        age: patient.age,
        condition: patient.condition,
        lastSeen: lastSeenValue,
        sessionsCount: patient.sessionsCount,
      );
      debugPrint('updatePatient response: ${response.data}');
    } catch (e) {
      debugPrint('Failed to update patient on backend: $e');
      // Continue with local update even if backend fails
    }

    _patients = _patients
        .map((Patient existing) => existing.id == patient.id ? patient : existing)
        .toList();
    await _save();
    notifyListeners();
  }

  Future<void> deletePatient(String patientId) async {
    try {
      final ApiService apiService = ApiService();
      await apiService.deletePatient(patientId: patientId);
    } catch (e) {
      debugPrint('Failed to delete patient from backend: $e');
      // Continue with local delete even if backend fails
    }

    _patients = _patients.where((Patient patient) => patient.id != patientId).toList();
    await _save();
    notifyListeners();
  }

  String generateId() => _uuid.v4();

  String? _extractPatientIdFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      for (final String key in <String>['id', '_id', 'patientId', 'patient_id']) {
        final dynamic value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
        if (value is int) {
          return value.toString();
        }
      }
      for (final dynamic nested in data.values) {
        final String? id = _extractPatientIdFromResponse(nested);
        if (id != null) {
          return id;
        }
      }
    }
    if (data is List) {
      for (final dynamic item in data) {
        final String? id = _extractPatientIdFromResponse(item);
        if (id != null) {
          return id;
        }
      }
    }
    return null;
  }

  Future<void> syncFromBackend() async {
    await loadFromBackend();
  }
  Future<void> clearAll() async {
  _patients = [];
  await _preferences.remove(_storageKey);
  notifyListeners();
}
  Future<void> _save() async {
    final String encoded = jsonEncode(_patients.map((Patient patient) => patient.toJson()).toList());
    await _preferences.setString(_storageKey, encoded);
  }
}
