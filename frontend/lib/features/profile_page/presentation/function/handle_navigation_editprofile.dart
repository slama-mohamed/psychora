import 'package:flutter/material.dart';
import 'package:psychora/features/edit_profile/presentation/page/edit_profile_page.dart';

void handleNavigationEditProfile(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const EditProfilePage()),
  );
}