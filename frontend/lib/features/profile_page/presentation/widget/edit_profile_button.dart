import 'package:flutter/material.dart';
import 'package:psychora/features/profile_page/presentation/function/handle_navigation_editprofile.dart';

class EditProfileButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditProfileButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () => handleNavigationEditProfile(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3D9970),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_outlined, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}