import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:psychora/core/constants/end_point_url.dart';
import 'package:psychora/features/patient_dashboard/data/patient_note_model.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/unauthorized_interceptor.dart';
import 'network_config.dart';
import 'token_store.dart';

class ApiService {
  ApiService._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl: NetworkConfig.baseUrl,
            connectTimeout: NetworkConfig.connectTimeout,
            receiveTimeout: NetworkConfig.receiveTimeout,
            sendTimeout: NetworkConfig.sendTimeout,
            headers: <String, dynamic>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _setupInterceptors();
  }

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  final Dio _dio;
  final TokenStore _tokenStore = TokenStore();

  UnauthorizedCallback? _onUnauthorized;

  Dio get dio => _dio;

  Future<void> setAuthToken(String token) async {
    await _tokenStore.saveToken(token);
  }

  Future<void> clearAuthToken() async {
    await _tokenStore.clearToken();
  }

  String? get currentToken => _tokenStore.accessToken;

  Future<void> readTokenFromStorage() async {
    final token = await _tokenStore.readToken();
    debugPrint('DEBUG: Token loaded from storage = $token');
  }

  void setUnauthorizedHandler(UnauthorizedCallback callback) {
    _onUnauthorized = callback;
  }

  Future<void> logout({
    String path = EndPointUrl.logout,
  }) async {
    try {
      await _dio.post<dynamic>(path);
    } finally {
      await clearAuthToken();
    }
  }

  Future<Response<dynamic>> loginUser({
    required String email,
    required String password,
    String path = EndPointUrl.login,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: <String, dynamic>{
        'email': email,
        'password': password,
      },
    );

    debugPrint('DEBUG: Login response = ${response.data}');
    final String? token = _extractAuthToken(response.data);
    debugPrint('DEBUG: Extracted token = $token');
    if (token != null && token.isNotEmpty) {
      await setAuthToken(token);
      debugPrint('DEBUG: Token saved successfully');
    } else {
      debugPrint('DEBUG: No token found in response');
    }

    return response;
  }

  String? _extractAuthToken(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      for (final String key in <String>['accessToken', 'token']) {
        final dynamic value = responseData[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }

      for (final dynamic nestedValue in responseData.values) {
        final String? nestedToken = _extractAuthToken(nestedValue);
        if (nestedToken != null && nestedToken.isNotEmpty) {
          return nestedToken;
        }
      }
    }

    return null;
  }

  Future<Response<dynamic>> signupPsychologist({
    required String fullName,
    required String email,
    required String password,
    required String specialty,
    required String idCard,
    required String hospital,
    required String location,
    required String phone,
    required int yearsOfExperience,
    String path = EndPointUrl.signup,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: <String, dynamic>{
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': 'Doctor',
        'specialty': specialty,
        'idCard': idCard,
        'hospital': hospital,
        'location': location,
        'phone': phone,
        'yearsOfExperience': yearsOfExperience,
      },
    );

    final String? token = _extractAuthToken(response.data);
    if (token != null && token.isNotEmpty) {
      await setAuthToken(token);
    }

    return response;
  }

  Future<Response<dynamic>> signupStudent({
    required String fullName,
    required String email,
    required String password,
    required String university,
    required String degree,
    required String year,
    required String location,
    required String phone,
    String path = EndPointUrl.signup,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: <String, dynamic>{
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': 'Student',
        'university': university,
        'degree': degree,
        'year': year,
        'location': location,
        'phone': phone,
      },
    );

    final String? token = _extractAuthToken(response.data);
    if (token != null && token.isNotEmpty) {
      await setAuthToken(token);
    }

    return response;
  }

  Future<Response<dynamic>> requestPasswordResetLink({
    required String email,
    String path = EndPointUrl.forgotPassword,
  }) async {
    return _dio.post<dynamic>(
      path,
      data: <String, dynamic>{
        'email': email,
      },
    );
  }

  Future<Response<dynamic>> resetPassword({
    required String newPassword,
    required String confirmPassword,
    String? email,
    String? token,
    String path = EndPointUrl.resetPassword,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };

    if (email != null && email.isNotEmpty) {
      data['email'] = email;
    }

    if (token != null && token.isNotEmpty) {
      data['token'] = token;
    }

    return _dio.post<dynamic>(
      path,
      data: data,
    );
  }

  Future<Response<dynamic>> addPatient({
    required String name,
    required int age,
    required String condition,
    required String lastSeen,
    required int sessionsCount,
    String path = EndPointUrl.addPatient,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'age': age,
      'condition': condition,
      'lastSeen': lastSeen,
      'sessionsCount': sessionsCount,
    };

    final Options options = Options(
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    );

    return _dio.post<dynamic>(
      path,
      data: data,
      options: options,
    );
  }

  Future<List<PatientModel>> getPatients({
    String path = EndPointUrl.addPatient,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(path);
    final List<Map<String, dynamic>> rows = _extractPatientRows(response.data);

    return rows
        .map((Map<String, dynamic> row) => PatientModel.fromMap(row))
        .where((PatientModel patient) {
          return patient.id.isNotEmpty || patient.name.isNotEmpty;
        })
        .toList();
  }

  Future<Response<dynamic>> updatePatient({
    required String patientId,
    required String name,
    required int age,
    required String condition,
    required String lastSeen,
    required int sessionsCount,
    String path = EndPointUrl.addPatient,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'age': age,
      'condition': condition,
      'lastSeen': lastSeen,
      'sessionsCount': sessionsCount,
    };

    return _dio.put<dynamic>(
      '$path/$patientId',
      data: data,
    );
  }

  Future<Response<dynamic>> deletePatient({
    required String patientId,
    String path = EndPointUrl.addPatient,
  }) async {
    return _dio.delete<dynamic>(
      '$path/$patientId',
    );
  }

  Future<Response<dynamic>> savePatientNote({
    required String patientId,
    required String note,
    String path = EndPointUrl.patientsNotes,
  }) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'patientId': patientId,
      'note': note,
    };

    try {
      return await _dio.put<dynamic>(
        '${EndPointUrl.patientsNotes}/$patientId',
        data: payload,
      );
    } on DioException catch (error) {
      if (!_shouldTryFallback(error.response?.statusCode)) {
        rethrow;
      }
    }

    try {
      return await _dio.put<dynamic>(
        '${EndPointUrl.addPatient}/$patientId/notes',
        data: <String, dynamic>{'note': note},
      );
    } on DioException catch (error) {
      if (!_shouldTryFallback(error.response?.statusCode)) {
        rethrow;
      }
    }

    try {
      return await _dio.post<dynamic>(
        EndPointUrl.patientsNotes,
        data: payload,
      );
    } on DioException catch (error) {
      if (!_shouldTryFallback(error.response?.statusCode)) {
        rethrow;
      }
    }

    return _dio.post<dynamic>(
      path,
      data: payload,
    );
  }

  Future<List<PatientNoteModel>> getPatientNotes({
    String path = EndPointUrl.patientsNotes,
    String? patientId,
  }) async {
    final String normalizedPatientId = (patientId ?? '').trim();
    final String primaryPath = normalizedPatientId.isEmpty
        ? EndPointUrl.patientsNotes
        : '${EndPointUrl.patientsNotes}/$normalizedPatientId';

    try {
      final Response<dynamic> response = await _dio.get<dynamic>(primaryPath);
      return _extractNoteRows(response.data)
          .map((Map<String, dynamic> row) => PatientNoteModel.fromMap(row))
          .where((PatientNoteModel note) {
        return note.patientId.isNotEmpty && note.note.trim().isNotEmpty;
      }).toList();
    } on DioException catch (error) {
      if (!_shouldTryFallback(error.response?.statusCode)) {
        rethrow;
      }
    }

    try {
      final Response<dynamic> fallbackResponse = await _dio.get<dynamic>(path);

      return _extractNoteRows(fallbackResponse.data)
          .map((Map<String, dynamic> row) => PatientNoteModel.fromMap(row))
          .where((PatientNoteModel note) {
        return note.patientId.isNotEmpty && note.note.trim().isNotEmpty;
      }).toList();
    } on DioException catch (error) {
      if (!_shouldTryFallback(error.response?.statusCode)) {
        rethrow;
      }
    }

    final Response<dynamic> secondFallbackResponse = await _dio.get<dynamic>(
      '${EndPointUrl.addPatient}/notes',
    );

    return _extractNoteRows(secondFallbackResponse.data)
        .map((Map<String, dynamic> row) => PatientNoteModel.fromMap(row))
        .where((PatientNoteModel note) {
      return note.patientId.isNotEmpty && note.note.trim().isNotEmpty;
    }).toList();
  }

  Future<void> deletePatientNote({
    required String patientId,
    String? noteId,
    String path = EndPointUrl.patientsNotes,
  }) async {
    final String normalizedPatientId = patientId.trim();
    final String normalizedNoteId = (noteId ?? '').trim();
    if (normalizedPatientId.isEmpty) {
      return;
    }

    final List<String> endpoints = <String>[
      if (normalizedNoteId.isNotEmpty) ...<String>[
        '${EndPointUrl.patientsNotes}/$normalizedNoteId',
        '${EndPointUrl.addPatient}/notes/$normalizedNoteId',
        '${EndPointUrl.addPatient}/$normalizedPatientId/notes/$normalizedNoteId',
      ],
      '${EndPointUrl.patientsNotes}/$normalizedPatientId',
      '${EndPointUrl.addPatient}/$normalizedPatientId/notes',
      '${EndPointUrl.addPatient}/notes/$normalizedPatientId',
    ];

    DioException? lastError;

    for (final String endpoint in endpoints.toSet()) {
      try {
        await _dio.delete<dynamic>(endpoint);
        return;
      } on DioException catch (error) {
        final int? statusCode = error.response?.statusCode;

        if (statusCode == 401 || statusCode == 403) {
          rethrow;
        }

        lastError = error;
      }
    }

    try {
      await savePatientNote(
        patientId: normalizedPatientId,
        note: '',
        path: path,
      );
      return;
    } on DioException {
      if (lastError != null) {
        throw lastError;
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPatientConversation({
    required String patientId,
    String path = EndPointUrl.patientConversation,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        '$path/$patientId',
      );
      return _extractConversationRows(response.data);
    } on DioException catch (error) {
      if (!_shouldTryFallback(error.response?.statusCode)) {
        rethrow;
      }

      final Response<dynamic> fallbackResponse = await _dio.get<dynamic>(
        path,
        queryParameters: <String, dynamic>{'patientId': patientId},
      );

      return _extractConversationRows(fallbackResponse.data);
    }
  }

  Future<Response<dynamic>> savePatientConversation({
    required String patientId,
    required List<Map<String, dynamic>> history,
    String path = EndPointUrl.patientConversation,
  }) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'patientId': patientId,
      'messages': history,
      'history': history,
    };

    try {
      return await _dio.post<dynamic>(
        path,
        data: payload,
      );
    } on DioException catch (error) {
      if (!_shouldTryFallback(error.response?.statusCode)) {
        rethrow;
      }
    }

    try {
      return await _dio.put<dynamic>(
        '$path/$patientId',
        data: <String, dynamic>{
          'messages': history,
          'history': history,
        },
      );
    } on DioException catch (error) {
      if (!_shouldTryFallback(error.response?.statusCode)) {
        rethrow;
      }
    }

    return _dio.post<dynamic>(
      '$path/$patientId',
      data: <String, dynamic>{
        'messages': history,
        'history': history,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getPsyConversations({
    String path = EndPointUrl.patientConversation,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(path);
    return _extractConversationRows(response.data);
  }

  Future<void> deleteConversationById({
    required String conversationId,
    String path = EndPointUrl.patientConversation,
  }) async {
    final String normalizedConversationId = conversationId.trim();
    if (normalizedConversationId.isEmpty) {
      return;
    }

    await _dio.delete<dynamic>('$path/$normalizedConversationId');
  }

  Future<Map<String, dynamic>> getCurrentUserData({
    String path = EndPointUrl.currentUser,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(path);
    final dynamic payload = response.data;

    if (payload is! Map<String, dynamic>) {
      return <String, dynamic>{};
    }

    return _mergeUserPayload(payload);
  }

  Future<Map<String, dynamic>> getCurrentUserProfile({
    String path = EndPointUrl.currentUser,
  }) {
    return getCurrentUserData(path: path);
  }

  Future<Response<dynamic>> updateCurrentUserProfile({
    required String fullName,
    required String email,
    required String phone,
    required String location,
    required String specialty,
    required String hospital,
    required int yearsOfExperience,
    required String bio,
    String path = EndPointUrl.currentUser,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'location': location,
      'specialty': specialty,
      'hospital': hospital,
      'yearsOfExperience': yearsOfExperience,
      'bio': bio,
    };

    return _dio.put<dynamic>(
      path,
      data: data,
    );
  }

  Map<String, dynamic> _mergeUserPayload(Map<String, dynamic> payload) {
    final Map<String, dynamic> merged = Map<String, dynamic>.from(payload);

    _mergeIfMap(merged, payload['data']);
    _mergeIfMap(merged, payload['user']);
    _mergeIfMap(merged, payload['profile']);

    final dynamic data = payload['data'];
    if (data is Map<String, dynamic>) {
      _mergeIfMap(merged, data['user']);
      _mergeIfMap(merged, data['profile']);
    }

    return merged;
  }

  void _mergeIfMap(Map<String, dynamic> target, dynamic value) {
    if (value is Map<String, dynamic>) {
      target.addAll(value);
    }
  }

  List<Map<String, dynamic>> _extractPatientRows(dynamic payload) {
    if (payload is List) {
      return payload.whereType<Map<String, dynamic>>().toList();
    }

    if (payload is Map<String, dynamic>) {
      final List<Map<String, dynamic>> directRows =
          _extractPatientRows(payload['patients']);
      if (directRows.isNotEmpty) {
        return directRows;
      }

      final List<Map<String, dynamic>> dataRows =
          _extractPatientRows(payload['data']);
      if (dataRows.isNotEmpty) {
        return dataRows;
      }

      final List<Map<String, dynamic>> resultRows =
          _extractPatientRows(payload['result']);
      if (resultRows.isNotEmpty) {
        return resultRows;
      }

      return <Map<String, dynamic>>[payload];
    }

    return <Map<String, dynamic>>[];
  }

  List<Map<String, dynamic>> _extractConversationRows(dynamic payload) {
    if (payload is List) {
      return payload.whereType<Map<String, dynamic>>().toList();
    }

    if (payload is Map<String, dynamic>) {
      for (final String key in <String>[
        'conversations',
        'conversation',
        'sessions',
        'chats',
        'rows',
        'result',
      ]) {
        final List<Map<String, dynamic>> rows = _extractConversationRows(payload[key]);
        if (rows.isNotEmpty) {
          return rows;
        }
      }

      final dynamic messages = payload['messages'] ?? payload['history'];
      if (messages is List) {
        return messages.whereType<Map<String, dynamic>>().toList();
      }

      final dynamic data = payload['data'];
      if (data is Map<String, dynamic>) {
        final dynamic nestedMessages = data['messages'] ?? data['history'];
        if (nestedMessages is List) {
          return nestedMessages.whereType<Map<String, dynamic>>().toList();
        }
      }

      return <Map<String, dynamic>>[payload];
    }

    return <Map<String, dynamic>>[];
  }

  List<Map<String, dynamic>> _extractNoteRows(dynamic payload) {
    if (payload is List) {
      return payload.whereType<Map<String, dynamic>>().toList();
    }

    if (payload is Map<String, dynamic>) {
      for (final String key in <String>[
        'notes',
        'data',
        'result',
        'rows',
      ]) {
        final List<Map<String, dynamic>> rows = _extractNoteRows(payload[key]);
        if (rows.isNotEmpty) {
          return rows;
        }
      }

      return <Map<String, dynamic>>[payload];
    }

    return <Map<String, dynamic>>[];
  }

  bool _shouldTryFallback(int? statusCode) {
    return statusCode == null || statusCode == 404 || statusCode == 405;
  }
  
  
  
  
  void _setupInterceptors() {
    _dio.interceptors
      ..clear()
      ..add(AuthInterceptor(tokenProvider: _tokenStore.readToken))
      ..add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (Object object) {
            developer.log(object.toString(), name: 'ApiService');
          },
        ),
      )
      ..add(
        UnauthorizedInterceptor(
          onUnauthorized: (DioException error) {
            _tokenStore.clearToken();
            _onUnauthorized?.call(error);
          },
        ),
      );
  }

}
