import 'package:flutter/material.dart';
import 'package:psychora/features/home/presentation/function/quickactioncontroller.dart';

class PatientDashboardController {
  static Future<void> handleAddPatient(BuildContext context) async {
    await QuickActionController.openAddPatientDialog(context);
  }
}
