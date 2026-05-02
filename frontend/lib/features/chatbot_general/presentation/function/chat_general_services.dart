import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:psychora/core/constants/end_point_url.dart';
import 'package:psychora/core/network/api_service.dart';

String getCurrentTime() {
  final now = DateTime.now();
  return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
}

class ChatGeneralServices {
  ChatGeneralServices({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Options _authOptions() {
    final String? token = _apiService.currentToken;
    debugPrint('DEBUG: Student chat token = $token');
    if (token != null && token.isNotEmpty) {
      return Options(headers: <String, dynamic>{
        'Authorization': 'Bearer $token',
      });
    }
    return Options();
  }

  Future<String> sendMessage({
    required String userMessage,
    List<Map<String, dynamic>> history = const <Map<String, dynamic>>[],
  }) async {
    try {
      final Response<dynamic> response = await _apiService.dio.post<dynamic>(
        EndPointUrl.chatbotMessage,
        data: <String, dynamic>{
          'message': userMessage,
          'history': history,
        },
        options: _authOptions(),
      );

      final String? parsedReply = _extractReply(response.data);
      if (parsedReply == null || parsedReply.trim().isEmpty) {
        throw Exception('Invalid chatbot response.');
      }

      return parsedReply;
    } on DioException catch (error) {
      throw Exception(_extractApiError(error));
    }
  }

  String? _extractReply(dynamic payload) {
    if (payload is String && payload.trim().isNotEmpty) {
      return payload;
    }

    if (payload is! Map<String, dynamic>) {
      return null;
    }

    const List<String> directKeys = <String>[
      'reply',
      'response',
      'message',
      'text',
      'answer',
      'content',
    ];

    for (final String key in directKeys) {
      final dynamic value = payload[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }

    final dynamic nestedData = payload['data'];
    if (nestedData is Map<String, dynamic>) {
      for (final String key in directKeys) {
        final dynamic value = nestedData[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
    }

    final dynamic choices = payload['choices'];
    if (choices is List && choices.isNotEmpty) {
      final dynamic firstChoice = choices.first;
      if (firstChoice is Map<String, dynamic>) {
        final dynamic message = firstChoice['message'];
        if (message is Map<String, dynamic>) {
          final dynamic content = message['content'];
          if (content is String && content.trim().isNotEmpty) {
            return content;
          }
        }
      }
    }

    return null;
  }

  // ==================== Student Chat Endpoints ====================

  /// Send a message for student chat
  /// 
  /// Sends a student message to the backend and retrieves the AI reply
  Future<String> sendStudentMessage({
    required String userMessage,
    List<Map<String, dynamic>> history = const <Map<String, dynamic>>[],
  }) async {
    try {
      final Response<dynamic> response = await _apiService.dio.post<dynamic>(
        EndPointUrl.studentMessage,
        data: <String, dynamic>{
          'message': userMessage,
          'history': history,
        },
        options: _authOptions(),
      );

      final String? parsedReply = _extractReply(response.data);
      if (parsedReply == null || parsedReply.trim().isEmpty) {
        throw Exception('Invalid student chat response.');
      }

      return parsedReply;
    } on DioException catch (error) {
      throw Exception(_extractApiError(error));
    }
  }

  /// Retrieve all student chat messages from database
  /// 
  /// Fetches the complete conversation history for the current student
  Future<List<Map<String, dynamic>>> getStudentMessages() async {
    try {
      final Response<dynamic> response =
          await _apiService.dio.get<dynamic>(
        EndPointUrl.studentMessages,
        options: _authOptions(),
      );

      // Handle different response formats
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(
          response.data as List<dynamic>,
        );
      } else if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data =
            response.data as Map<String, dynamic>;

        // Try to extract messages from common response structures
        if (data['messages'] is List) {
          return List<Map<String, dynamic>>.from(
            data['messages'] as List<dynamic>,
          );
        } else if (data['data'] is List) {
          return List<Map<String, dynamic>>.from(
            data['data'] as List<dynamic>,
          );
        } else if (data['conversations'] is List) {
          return List<Map<String, dynamic>>.from(
            data['conversations'] as List<dynamic>,
          );
        }
      }

      return <Map<String, dynamic>>[];
    } on DioException catch (error) {
      throw Exception(_extractApiError(error));
    }
  }

  /// Delete/clear all student chat messages from database
  /// 
  /// Clears the entire conversation history for the current student
  Future<void> clearStudentMessages() async {
    try {
      await _apiService.dio.delete<dynamic>(
        EndPointUrl.clearStudentMessages,
        options: _authOptions(),
      );
    } on DioException catch (error) {
      throw Exception(_extractApiError(error));
    }
  }

  String _extractApiError(DioException error) {
    final dynamic responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      const List<String> errorKeys = <String>[
        'message',
        'error',
        'detail',
        'description',
      ];

      for (final String key in errorKeys) {
        final dynamic value = responseData[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
    }

    return 'Network error while communicating with the chatbot.';
  }


}
