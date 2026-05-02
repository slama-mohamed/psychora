import 'package:flutter/material.dart';
import 'package:psychora/common/widgets/bottom_navigation/home_bottom_navigation_bar.dart';
import 'package:psychora/features/profile_page/presentation/widget/appbar_profile.dart';
import 'package:psychora/features/profile_page/presentation/widget/profilepage_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: ProfileAppBar(),
      body: SafeArea(
        child: const ProfilepageForm(),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(),
    );
  }

  
}