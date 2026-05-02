import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  static const String _key = 'auth_token';

  String? _accessToken;

  String? get accessToken => _accessToken;

  Future<String?> readToken() async {
    if (_accessToken != null) {
      debugPrint('DEBUG: Token already in memory: $_accessToken');
      return _accessToken;
    }
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_key);
    debugPrint('DEBUG: Token read from SharedPreferences: $_accessToken');
    return _accessToken;
  }

  Future<void> saveToken(String token) async {
    _accessToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
    debugPrint('DEBUG: Token saved to SharedPreferences: $token');
  }

  Future<void> clearToken() async {
    _accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    debugPrint('DEBUG: Token cleared from SharedPreferences');
  }
}
