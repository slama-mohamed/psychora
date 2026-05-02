import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';

class Backtosignup extends StatelessWidget {
  const Backtosignup({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
                onPressed: () {
                  context.goNamed(RouteName.signupName);
                },
                child: Text(
                  'Back to Sign Up',
                  // ignore: deprecated_member_use
                  style: TextStyle(color: Colors.grey.withOpacity(0.7), fontWeight: FontWeight.w500),
                ),
              ) ;
  }
}