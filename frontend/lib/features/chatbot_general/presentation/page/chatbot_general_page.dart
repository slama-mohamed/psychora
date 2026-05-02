import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/chatbot_interface/data/chat_conversation_store.dart';
import 'package:psychora/features/patient_dashboard/data/patient_notes_store.dart';
import 'package:psychora/features/patient_dashboard/data/patient_store.dart';
import 'package:psychora/features/chatbot_general/presentation/widget/chat_general_form.dart';

class ChatbotGeneralPage extends StatefulWidget {
  const ChatbotGeneralPage({super.key});

  @override
  State<ChatbotGeneralPage> createState() => _ChatbotGeneralPageState();
}

class _ChatbotGeneralPageState extends State<ChatbotGeneralPage> {
  final ApiService _apiService = ApiService();

  Future<void> _handleLogout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Do you really want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    try {
      await _apiService.logout();
    } catch (_) {
      await _apiService.clearAuthToken();
    }

    // Vider toutes les données en mémoire
    PatientStore().clearAll();
    PatientNotesStore().clearAll();
    ChatConversationStore().clearAll();

    if (!mounted) {
      return;
    }

    context.goNamed(RouteName.loginName);
  }

  void _showResourcesSheet() {
    if (!mounted) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.46,
          minChildSize: 0.28,
          maxChildSize: 0.92,
          expand: false,
          builder: (BuildContext _, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const Text(
                      'Ressources',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Accédez aux articles, vidéos et documents utiles pour vos études.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        _resourceCard(Icons.article_outlined, 'Articles', () {
                          Navigator.of(ctx).pop();
                          context.goNamed(
                            RouteName.resourcesPage,
                            extra: {'showBottomNavigationBar': false},
                          );
                        }),
                        _resourceCard(Icons.play_circle_outline, 'Vidéos', () {
                          Navigator.of(ctx).pop();
                          context.goNamed(
                            RouteName.resourcesPage,
                            extra: {'showBottomNavigationBar': false},
                          );
                        }),
                        _resourceCard(Icons.picture_as_pdf_outlined, 'PDFs', () {
                          Navigator.of(ctx).pop();
                          context.goNamed(
                            RouteName.resourcesPage,
                            extra: {'showBottomNavigationBar': false},
                          );
                        }),
                        _resourceCard(Icons.school_outlined, 'Cours', () {
                          Navigator.of(ctx).pop();
                          context.goNamed(
                            RouteName.resourcesPage,
                            extra: {'showBottomNavigationBar': false},
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          context.goNamed(
                            RouteName.resourcesPage,
                            extra: {'showBottomNavigationBar': false},
                          );
                        },
                        child: const Text('Voir toutes les ressources', style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _resourceCard(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E9F2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEBFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF4F46E5), size: 22),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
            const SizedBox(height: 6),
            const Expanded(child: SizedBox()),
            const Align(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Psychora Chatbot',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.goNamed(
              RouteName.resourcesPage,
              extra: {'showBottomNavigationBar': false},
            ),
            tooltip: 'Ressources',
            icon: const Icon(
              Icons.menu_book_outlined,
              color: Color(0xFF374151),
            ),
          ),
          IconButton(
            onPressed: _handleLogout,
            tooltip: 'Logout',
            icon: const Icon(
              Icons.logout_outlined,
              color: Color(0xFFDC2626),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ChatGeneralForm(),
        ),
      ),
    );
  }
}
