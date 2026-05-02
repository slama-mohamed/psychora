import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';

void handleSignupNavigation(BuildContext context) {
  context.pushNamed(RouteName.signupName);
}