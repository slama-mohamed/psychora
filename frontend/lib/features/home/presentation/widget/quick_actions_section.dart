import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/features/home/presentation/function/quickactioncontroller.dart';
import 'package:psychora/features/home/presentation/widget/home_form_data.dart';
import 'package:psychora/features/home/presentation/widget/quickactiontile.dart';
class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemCount: HomeFormData.quickActions.length,
              itemBuilder: (context, index) {
                final item = HomeFormData.quickActions[index];
                VoidCallback? action = item.onTap;

                if (item.title == 'New Patient') {
                  action = () async {
                    await QuickActionController.openAddPatientDialog(context);
                  };
                }

                if (item.title == 'Start Chat') {
                  action = () {
                    QuickActionController.handleNavigateToChat(context);
                  };
                }

                if (item.title == 'Resources') {
                  action = () {
                    QuickActionController.handleNavigateToResources(context);
                  };
                }

                if (item.title == 'All Notes') {
                  action = () {
                    context.pushNamed(RouteName.allNotesPage);
                  };
                }
                
                return QuickActionTile(item: item, onTap: action);
              },
            ),
          ],
        ),
      ),
    );
  }
}
