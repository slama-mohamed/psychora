import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';

class AppNavigationFunctions {

  static void navigateToDoctorProfile(
    BuildContext context, {
    Map<String, dynamic>? signupData,
  }) {
    context.pushNamed(RouteName.doctorprofilepage, extra: signupData);
  }

  static void navigateToCompleteProfileStudent(BuildContext context, {Map<String, dynamic>? signupData}) {
    context.pushNamed(RouteName.completeProfileStudent, extra: signupData);
  }

  static void navigateToLogin(BuildContext context) {
    context.pushNamed(RouteName.loginName);
  }
}