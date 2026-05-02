import 'package:flutter/material.dart';
import 'package:psychora/features/patient_dashboard/presentation/function/patientdashboardcontroller.dart';
import 'package:psychora/features/patient_dashboard/presentation/widget/actionbuttondashboard.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  // ← obligatoire pour un AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3D9970), Color(0xFF2d7a5c)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.people_alt_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Patient management',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Actionbuttondashboard(
          icon: Icons.add_circle_outline,
          label: 'Add Patient',
          onPressed: () {
            PatientDashboardController.handleAddPatient(context);
          },
        ),
       
        const SizedBox(width: 8),
      ],
      centerTitle: false,
    );
  }
}