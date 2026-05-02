import 'package:flutter/material.dart';
import 'package:psychora/common/widgets/bottom_navigation/home_bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import '../widget/resources_form.dart';

class ResourcesPage extends StatelessWidget {
  final bool showBottomNavigationBar;
  final bool showAppBar;

  const ResourcesPage({super.key, this.showBottomNavigationBar = true, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: showAppBar ? AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: showBottomNavigationBar ? null : IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF374151)),
          onPressed: () => context.goNamed(RouteName.chatbotGeneral),
          tooltip: 'Retour au chat',
        ),
        title: const Text(
          'Resources',
          style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ) : null,
      body: const SafeArea(
        child: ResourcesForm(),
      ),
      bottomNavigationBar: showBottomNavigationBar ? const HomeBottomNavigationBar() : null,
    );
  }
}