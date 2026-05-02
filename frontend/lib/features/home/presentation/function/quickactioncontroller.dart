import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/features/home/presentation/widget/add_patient_dialog.dart';
import 'package:psychora/features/patients/domain/models/patient.dart';
import 'package:psychora/features/patients/presentation/providers/patient_provider.dart';

class QuickActionController {
  static Future<Patient?> openAddPatientDialog(BuildContext context) async {
    final Patient? result = await showDialog<Patient>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const AddPatientDialog(),
    );

    if (result == null) {
      return null;
    }

    final PatientProvider provider = Provider.of<PatientProvider>(context, listen: false);
    final String id = result.id.isNotEmpty ? result.id : provider.generateId();
    final Patient patient = result.copyWith(id: id);

    try {
      await provider.addPatient(patient).timeout(const Duration(seconds: 60));
    } catch (_) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.hideCurrentSnackBar();
      messenger?.showSnackBar(
        const SnackBar(
          content: Text('Failed to save the patient locally.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return null;
    }

    return patient;
  }

  static void handleNavigateToChat(BuildContext context) {
    context.pushNamed(RouteName.chatbotGeneral);
  }

  static void handleNavigateToResources(BuildContext context) {
    context.goNamed(RouteName.resourcesPage);
  }
}
