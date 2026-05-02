import 'package:flutter/material.dart';
import 'home_header.dart';
import 'quick_actions_section.dart';
import 'recent_activity_section.dart';

/// Static home page content (no backend yet).
///
/// This follows the pattern used elsewhere in the app (e.g. `LoginForm`).
class HomeForm extends StatelessWidget {
  const HomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          HomeHeader(),
          SizedBox(height: 20),
          RecentActivitySection(),
          SizedBox(height: 20),
          QuickActionsSection(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
