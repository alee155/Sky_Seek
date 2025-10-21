import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_seek/models/profile_model.dart';
import 'package:sky_seek/config/api_config.dart';

class UpdateProfileService {
  /// Updates user profile through the API and returns both model and raw response
  static Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String gender,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.editProfileEndpoint);
      debugPrint('==========================================');
      debugPrint('PROFILE UPDATE API REQUEST:');
      debugPrint('URL: ${url.toString()}');
      debugPrint('REQUEST BODY: {"firstName": "$firstName", "lastName": "$lastName", "gender": "$gender"}');
      debugPrint('HEADERS: Authorization: Bearer ${token.substring(0, 10)}... (truncated)');
      debugPrint('==========================================');

      final response = await http
          .put(
            url,
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "firstName": firstName,
              "lastName": lastName,
              "gender": gender,
            }),
          )
          .timeout(const Duration(seconds: 10));

      // Print detailed response to terminal
      debugPrint('==========================================');
      debugPrint('PROFILE UPDATE API RESPONSE:');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');
      debugPrint('==========================================');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        
        // Create updated profile model
        final updatedProfile = ProfileModel.fromJson(decoded);
        
        // Update local cache
        await _saveProfileToLocal(updatedProfile);
        
        debugPrint('Profile updated successfully');
        return {
          'success': true,
          'profile': updatedProfile,
          'rawResponse': decoded,
          'statusCode': response.statusCode
        };
      } else {
        debugPrint("Failed to update profile: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        
        // Return failure with raw response for debugging
        Map<String, dynamic> rawResponse = {};
        try {
          rawResponse = jsonDecode(response.body);
        } catch (e) {
          rawResponse = {'error': 'Failed to parse response body: ${response.body}'};
        }
        
        return {
          'success': false,
          'profile': null,
          'rawResponse': rawResponse,
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      return {
        'success': false,
        'profile': null,
        'rawResponse': {'error': e.toString()},
        'statusCode': -1
      };
    }
  }
  
  // Save profile to shared preferences
  static Future<bool> _saveProfileToLocal(ProfileModel profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileMap = {
        '_id': profile.id,
        'firstName': profile.firstName,
        'lastName': profile.lastName,
        'email': profile.email,
        'gender': profile.gender,
        'favoritePlanets': profile.favoritePlanets,
        'createdAt': profile.createdAt,
        'updatedAt': profile.updatedAt,
      };
      
      // Save timestamp of when the profile was cached
      await prefs.setInt('user_profile_timestamp', DateTime.now().millisecondsSinceEpoch);
      
      // Save profile data as JSON string
      return await prefs.setString('user_profile', jsonEncode(profileMap));
    } catch (e) {
      debugPrint("Error saving profile locally: $e");
      return false;
    }
  }
}
