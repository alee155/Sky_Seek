import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sky_seek/models/galaxy_model.dart';
import 'package:sky_seek/config/api_config.dart';

class GalaxyService {
  static Future<List<Galaxy>> fetchGalaxies(String token) async {
    debugPrint("===== STARTING GALAXIES FETCH =====");
    
    try {
      final url = Uri.parse(
        ApiConfig.galaxiesEndpoint,
      );
      
      // Prepare headers with authentication token
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      debugPrint("Fetching galaxies with token: ${token.isNotEmpty ? 'Valid token' : 'Empty token'}");
      debugPrint("Making API call to: ${url.toString()}");
      
      final response = await http.get(url, headers: headers);
      
      // Print API response in terminal for debugging
      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Galaxies API Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Debug the response structure
        debugPrint("API Response Structure: ${responseData.runtimeType}");
        
        List galaxiesData;
        if (responseData is List) {
          galaxiesData = responseData;
          debugPrint("Response is a list with ${galaxiesData.length} galaxies");
        } else if (responseData is Map && responseData.containsKey('galaxies')) {
          galaxiesData = responseData['galaxies'];
          debugPrint("Response is a map with 'galaxies' key, found ${galaxiesData.length} galaxies");
        } else {
          throw Exception("Unexpected API response format");
        }
        
        final galaxies = galaxiesData.map((e) => Galaxy.fromJson(e)).toList();
        debugPrint("Successfully parsed ${galaxies.length} galaxies");
        return galaxies;
      } else {
        throw Exception("Failed to load galaxies. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("===== ERROR FETCHING GALAXIES =====");
      debugPrint(e.toString());
      rethrow;
    }
  }

  static Future<Galaxy> fetchGalaxyDetails(String token, String galaxyId) async {
    debugPrint("===== STARTING GALAXY DETAILS FETCH =====");
    
    try {
      final url = Uri.parse(
        ApiConfig.galaxyDetailsEndpoint,
      );
      
      // Prepare headers with authentication token
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      // Prepare request body with galaxy ID
      final body = jsonEncode({"galaxyId": galaxyId});
      
      debugPrint("Making API call to: ${url.toString()}");
      debugPrint("With body: $body");
      
      final response = await http.post(url, headers: headers, body: body);
      
      // Print API response in terminal for debugging
      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Galaxy details API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final galaxy = Galaxy.fromJson(data);
        debugPrint("Successfully parsed galaxy: ${galaxy.name}");
        return galaxy;
      } else {
        throw Exception("Failed to load galaxy details. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("===== ERROR FETCHING GALAXY DETAILS =====");
      debugPrint(e.toString());
      rethrow;
    }
  }
}
