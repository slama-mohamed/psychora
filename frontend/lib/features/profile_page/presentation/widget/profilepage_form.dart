import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/profile_page/data/user_profile_model.dart';
import 'package:psychora/features/profile_page/presentation/widget/action_buttons.dart';
import 'package:psychora/features/profile_page/presentation/widget/information_section.dart';
import 'package:psychora/features/profile_page/presentation/widget/profile_header.dart';
import 'package:psychora/features/chatbot_interface/data/chat_conversation_store.dart';
import 'package:psychora/features/patient_dashboard/data/patient_notes_store.dart';
import 'package:psychora/features/patient_dashboard/data/patient_store.dart';

class ProfilepageForm extends StatefulWidget {
  const ProfilepageForm({super.key});

  @override
  State<ProfilepageForm> createState() => _ProfilepageFormState();
}

class _ProfilepageFormState extends State<ProfilepageForm> {
  bool _isEditing = false;
  final ApiService _apiService = ApiService();
  late Future<UserProfileModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadUserProfile();
  }

  Future<UserProfileModel> _loadUserProfile() async {
    final Map<String, dynamic> payload = await _apiService.getCurrentUserData();
    return UserProfileModel.fromApi(payload);
  }

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
      // Continue local logout flow even if backend endpoint fails.
      await _apiService.clearAuthToken();
    }

    // Vider toutes les données en mémoire pour éviter les fuites entre comptes
    PatientStore().clearAll();
    PatientNotesStore().clearAll();
    ChatConversationStore().clearAll();

    if (!mounted) {
      return;
    }

    context.goNamed(RouteName.loginName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: FutureBuilder<UserProfileModel>(
        future: _profileFuture,
        builder: (BuildContext context, AsyncSnapshot<UserProfileModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3D9970),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Color(0xFFDC2626),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to load your information.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _profileFuture = _loadUserProfile();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D9970),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final UserProfileModel profile =
              snapshot.data ?? UserProfileModel.fromApi(<String, dynamic>{});

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                ProfileHeader(
                  initials: profile.initials,
                  name: profile.fullName,
                  profession: profile.profession,
                  isAvailable: profile.isAvailable,
                ),
                const SizedBox(height: 30),

                InformationSection(
                  email: profile.email,
                  phone: profile.phone,
                  location: profile.location,
                  specialization: profile.specialization,
                ),
                const SizedBox(height: 30),

                ActionButtons(
                  onEdit: () {
                    setState(() => _isEditing = !_isEditing);
                  },
                  onLogout: _handleLogout,
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
