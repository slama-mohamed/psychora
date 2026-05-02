import 'package:flutter/material.dart';
import 'package:psychora/features/patients/domain/models/patient.dart';

class HeaderText extends StatelessWidget {
  final List<Patient> filteredPatients;
  const HeaderText({super.key, required this.filteredPatients});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${filteredPatients.length} patient${filteredPatients.length > 1 ? 's' : ''} available${filteredPatients.length > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
