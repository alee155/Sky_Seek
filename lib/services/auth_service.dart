import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_seek/services/profile_service.dart';

class AuthService {
  // Test function to check if shared_preferences is working
  static Future<bool> testSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('test_key', 'test_value');
      final value = prefs.getString('test_key') ?? '';
      debugPrint('Shared Preferences Test: $value');
      return value == 'test_value';
    } catch (e) {
      debugPrint('Shared Preferences Test Error: $e');
      return false;
    }
  }
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  // Save token to SharedPreferences
  static Future<bool> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_tokenKey, token);
  }

  // Get token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Save user ID
  static Future<bool> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userIdKey, userId);
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear auth data (for logout)
  static Future<bool> logout() async {
    try {
      // Clear profile cache when logging out
      await ProfileService.clearProfileCache();
      
      // Clear auth data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      return prefs.remove(_tokenKey);
    } catch (e) {
      debugPrint('Error during logout: $e');
      return false;
    }
  }
}
