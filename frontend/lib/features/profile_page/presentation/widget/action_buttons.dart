import 'package:flutter/material.dart';
import 'package:psychora/features/profile_page/presentation/widget/edit_profile_button.dart';
import 'package:psychora/features/profile_page/presentation/widget/logout_button.dart';
import 'package:psychora/features/profile_page/presentation/widget/settings_button.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback? onSettings;
  final VoidCallback onLogout;

  const ActionButtons({
    super.key,
    required this.onEdit,
    this.onSettings,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          EditProfileButton(onPressed: onEdit),
          if (onSettings != null) ...[
            const SizedBox(height: 12),
            SettingsButton(onPressed: onSettings!),
          ],
          const SizedBox(height: 12),
          LogoutButton(onPressed: onLogout),
        ],
      ),
    );
  }
}