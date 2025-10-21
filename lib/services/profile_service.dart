import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_seek/models/profile_model.dart';
import 'package:sky_seek/config/api_config.dart';

class ProfileService {
  // Keys for storing user profile in shared preferences
  static const String _profileKey = 'user_profile';
  static const String _profileTimestampKey = 'user_profile_timestamp';

  /// Try to load profile from local storage first, if not available or forced refresh,
  /// fetch from API. This provides a seamless offline experience.
  static Future<ProfileModel?> getProfile(String token, {bool forceRefresh = false}) async {
    // If not forcing refresh, try to load from local storage first
    if (!forceRefresh) {
      final cachedProfile = await _getProfileFromLocal();
      if (cachedProfile != null) {
        debugPrint('Loaded profile from local storage: ${cachedProfile.firstName} ${cachedProfile.lastName}');
        return cachedProfile;
      }
    }

    // If no cached data or forced refresh, fetch from API
    return await fetchProfileFromApi(token);
  }

  /// Fetch profile directly from API
  static Future<ProfileModel?> fetchProfileFromApi(String token) async {
    try {
      final url = Uri.parse(ApiConfig.profileEndpoint);
      debugPrint('Fetching profile from API...');

      final response = await http
          .get(
            url,
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final profile = ProfileModel.fromJson(decoded);

        // Cache profile
        await _saveProfileToLocal(profile);
        debugPrint('Profile fetched from API and cached locally');

        return profile;
      } else {
        debugPrint("Failed to fetch profile: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        // Try to get from cache as fallback
        return await _getProfileFromLocal();
      }
    } on TimeoutException catch (e) {
      debugPrint("Request timeout: $e");
      return await _getProfileFromLocal();
    } on SocketException catch (e) {
      debugPrint("Network error (SocketException): $e");
      return await _getProfileFromLocal();
    } on HttpException catch (e) {
      debugPrint("HTTP error: $e");
      return await _getProfileFromLocal();
    } catch (e) {
      debugPrint("Error fetching profile from API: $e");
      return await _getProfileFromLocal();
    }
  }

  // Save profile to shared preferences with timestamp
  static Future<bool> _saveProfileToLocal(ProfileModel profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileMap = {
        '_id': profile.id,  // Changed to _id to match API response format
        'firstName': profile.firstName,
        'lastName': profile.lastName,
        'email': profile.email,
        'gender': profile.gender,
        'favoritePlanets': profile.favoritePlanets,
        'createdAt': profile.createdAt,
        'updatedAt': profile.updatedAt,
      };
      
      // Save timestamp of when the profile was cached
      await prefs.setInt(_profileTimestampKey, DateTime.now().millisecondsSinceEpoch);
      
      // Save profile data as JSON string
      return await prefs.setString(_profileKey, jsonEncode(profileMap));
    } catch (e) {
      debugPrint("Error saving profile locally: $e");
      return false;
    }
  }

  // Get profile from shared preferences
  static Future<ProfileModel?> _getProfileFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileString = prefs.getString(_profileKey);

      if (profileString != null && profileString.isNotEmpty) {
        final profileMap = jsonDecode(profileString);
        return ProfileModel.fromJson(profileMap);
      }
      return null;
    } catch (e) {
      debugPrint("Error getting profile from local storage: $e");
      return null;
    }
  }
  
  // Clear cached profile data (useful for logout)
  static Future<bool> clearProfileCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
      await prefs.remove(_profileTimestampKey);
      return true;
    } catch (e) {
      debugPrint("Error clearing profile cache: $e");
      return false;
    }
  }
}
