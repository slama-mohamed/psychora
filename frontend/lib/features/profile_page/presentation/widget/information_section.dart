import 'package:flutter/material.dart';
import 'package:psychora/features/profile_page/presentation/widget/infor_card.dart';

class InformationSection extends StatelessWidget {
  const InformationSection({
    super.key,
    required this.email,
    required this.phone,
    required this.location,
    required this.specialization,
  });

  final String email;
  final String phone;
  final String location;
  final String specialization;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INFORMATION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          InfoCard(
            icon: Icons.email_outlined,
            label: 'Email',
            value: email,
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: phone,
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: location,
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.business_outlined,
            label: 'Specialization',
            value: specialization,
          ),
        ],
      ),
    );
  }
}