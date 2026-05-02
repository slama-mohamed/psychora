import 'package:flutter/material.dart';
import 'package:psychora/common/widgets/bottom_navigation/home_bottom_navigation_bar.dart';
import 'package:psychora/features/patient_dashboard/presentation/widget/appbar_dashboard.dart';
import 'package:psychora/features/patient_dashboard/presentation/widget/patientdashboardform.dart';

class PatientDashboardPage extends StatelessWidget {
  const PatientDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Patientdashboardform(),
      ),
      bottomNavigationBar: const HomeBottomNavigationBar(isDoctor: false),
    );
  }
}
  