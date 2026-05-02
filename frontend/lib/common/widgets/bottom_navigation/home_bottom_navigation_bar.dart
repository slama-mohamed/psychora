import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/common/widgets/bottom_navigation/bottombutton.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/core/navigation/app_router.dart';


class HomeBottomNavigationBar extends StatefulWidget {
  final bool isDoctor;

  const HomeBottomNavigationBar({super.key, this.isDoctor = false});

  @override
  State<HomeBottomNavigationBar> createState() =>
      _HomeBottomNavigationBarState();
}

class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  int _getIndexFromLocation(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.contains(AppRouter.patientdashboardpage)) {
      return 1;
    } else if (location.contains(AppRouter.resourcesPage)) {
      return 2;
    } else if (location.contains(AppRouter.profilepage)) {
      return 3;
    }
    return 0; // Home par défaut
  }

  void _onItemTapped(int index) {
    // Navigation logic
    switch (index) {
      case 0:
        context.goNamed(RouteName.home);
        break;
      case 1:
        context.goNamed(RouteName.patientdashboardpage);
        break;
      case 2:
        context.goNamed(RouteName.resourcesPage, extra: {'showBottomNavigationBar': true, 'showAppBar': !widget.isDoctor});
        break;
      case 3:
        context.goNamed(RouteName.profilepage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getIndexFromLocation(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomButton(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            isActive: selectedIndex == 0,
            onTap: () => _onItemTapped(0),
          ),
          BottomButton(
            icon: Icons.people_outline,
            activeIcon: Icons.people,
            label: 'Patients',
            isActive: selectedIndex == 1,
            onTap: () => _onItemTapped(1),
          ),
          BottomButton(
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book,
            label: 'Resources',
            isActive: selectedIndex == 2,
            onTap: () => _onItemTapped(2),
          ),
          BottomButton(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profile',
            isActive: selectedIndex == 3,
            onTap: () => _onItemTapped(3),
          ),
        ],
      ),
    );
  }
}

