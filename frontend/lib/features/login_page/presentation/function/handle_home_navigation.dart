import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/chatbot_interface/data/chat_conversation_store.dart';
import 'package:psychora/features/patient_dashboard/data/patient_notes_store.dart';
import 'package:psychora/features/patient_dashboard/data/patient_store.dart';
import 'package:psychora/features/patients/presentation/providers/patient_provider.dart';

Future<void> handleHomeNavigation({
  required BuildContext context,
  required String email,
  required String password,
  String loginPath = '/api/psy/login',
}) async {
  final messenger = ScaffoldMessenger.maybeOf(context);

  try {
    // ✅ Vider TOUTES les données avant login
    PatientStore().clearAll();
    PatientNotesStore().clearAll();
    ChatConversationStore().clearAll();
    await context.read<PatientProvider>().clearAll(); // ← clé du fix
    await ApiService().clearAuthToken();

    final response = await ApiService().loginUser(
      email: email,
      password: password,
      path: loginPath,
    );

    if (!context.mounted) return;

    final String? role = _extractRole(response.data);
    if (role == 'student') {
      context.goNamed(RouteName.chatbotGeneral);
      return;
    }

    context.goNamed(RouteName.home);
  } on DioException catch (error) {
    if (!context.mounted) return;
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        content: Text(_resolveApiErrorMessage(error)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (_) {
    if (!context.mounted) return;
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      const SnackBar(
        content: Text('Unexpected error during login.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

String? _extractRole(dynamic responseData) {
  if (responseData is! Map<String, dynamic>) {
    return null;
  }

  final List<dynamic> candidates = <dynamic>[
    responseData['role'],
    responseData['userRole'],
    responseData['type'],
    responseData['account'] is Map<String, dynamic>
        ? (responseData['account'] as Map<String, dynamic>)['role']
        : null,
    responseData['user'] is Map<String, dynamic>
        ? (responseData['user'] as Map<String, dynamic>)['role']
        : null,
  ];

  for (final dynamic candidate in candidates) {
    final String normalized = candidate?.toString().trim().toLowerCase() ?? '';
    if (normalized.isNotEmpty) {
      return normalized;
    }
  }

  return null;
}

String _resolveApiErrorMessage(DioException error) {
  final statusCode = error.response?.statusCode;

  if (statusCode == 401) {
    return 'Email or password is incorrect.';
  }

  final data = error.response?.data;
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message;
    }
  }

  return 'Login failed. Please try again.';
}