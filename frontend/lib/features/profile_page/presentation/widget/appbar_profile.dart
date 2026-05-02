import 'package:flutter/material.dart';
import 'package:psychora/features/profile_page/presentation/widget/actionbuttonprofile.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

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
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
      ),
      title: const Text(
        'My Profile',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1F2937),
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      actions: [
        Actionbuttonprofile(
          icon: Icons.notifications_outlined,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}