import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'auth_token';
  static String? _cachedToken;

  // Get token from cache or shared preferences
  static Future<String?> getToken() async {
    // Return cached token if available
    if (_cachedToken != null && _cachedToken!.isNotEmpty) {
      return _cachedToken;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedToken = prefs.getString(_tokenKey);
      debugPrint("Token retrieved from storage: ${_cachedToken?.isNotEmpty == true ? 'Valid token' : 'No token found'}");
      return _cachedToken;
    } catch (e) {
      debugPrint("Error retrieving token: $e");
      return null;
    }
  }

  // Save token to shared preferences and cache
  static Future<bool> saveToken(String token) async {
    if (token.isEmpty) {
      debugPrint("Warning: Attempting to save empty token");
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.setString(_tokenKey, token);
      if (result) {
        _cachedToken = token;
        debugPrint("Token saved successfully");
      }
      return result;
    } catch (e) {
      debugPrint("Error saving token: $e");
      return false;
    }
  }

  // Clear token from shared preferences and cache
  static Future<bool> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.remove(_tokenKey);
      if (result) {
        _cachedToken = null;
        debugPrint("Token cleared successfully");
      }
      return result;
    } catch (e) {
      debugPrint("Error clearing token: $e");
      return false;
    }
  }
}
