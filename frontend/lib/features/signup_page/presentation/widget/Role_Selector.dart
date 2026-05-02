import 'package:flutter/material.dart';
import 'package:psychora/core/constants/assets_constant.dart';
import 'package:psychora/features/signup_page/presentation/widget/role_card.dart';


class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CHOOSE YOUR ROLE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: RoleCard(
                label: 'Doctor',
                imagePath: AssetsConstant.doctorLogo,
                isSelected: selectedRole == 'Doctor',
                onTap: () => onRoleChanged('Doctor'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RoleCard(
                label: 'Student',
                imagePath: AssetsConstant.studentLogo,
                isSelected: selectedRole == 'Student',
                onTap: () => onRoleChanged('Student'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
