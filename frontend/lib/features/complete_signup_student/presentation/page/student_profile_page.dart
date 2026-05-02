import 'package:flutter/material.dart';
import 'package:psychora/features/complete_signup_student/presentation/widget/complete_form.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CompleteProfileStudent(),
      ),
    );
  }
}
