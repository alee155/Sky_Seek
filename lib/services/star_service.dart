import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sky_seek/models/star_model.dart';
import 'package:sky_seek/config/api_config.dart';

class StarService {
  static Future<List<Star>> fetchStars(String token) async {
    final url = Uri.parse(
      ApiConfig.starsEndpoint,
    );
    
    // Prepare headers with authentication token
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    debugPrint("Fetching stars with token: $token");
    
    final response = await http.get(url, headers: headers);
    
    // Print API response in terminal for debugging
    debugPrint("Stars API Response: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      
      // Print API response for debugging
      debugPrint("API Response Structure: ${responseData.runtimeType}");
      
      List starsData;
      if (responseData is List) {
        starsData = responseData;
      } else if (responseData is Map && responseData.containsKey('stars')) {
        starsData = responseData['stars'];
      } else {
        throw Exception("Unexpected API response format");
      }
      
      return starsData.map((e) => Star.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load stars. Status code: ${response.statusCode}");
    }
  }

  static Future<Star> fetchStarDetails(String token, String starId) async {
    debugPrint("===== STARTING STAR DETAILS FETCH =====");
    debugPrint("Token available: ${token.isNotEmpty}");
    debugPrint("Star ID: $starId");
    
    try {
      final url = Uri.parse(
        ApiConfig.starDetailsEndpoint,
      );
      
      // Prepare headers with authentication token
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      // Prepare request body with star ID
      final body = jsonEncode({"starId": starId});
      
      debugPrint("Making API call to: ${url.toString()}");
      debugPrint("With headers: $headers");
      debugPrint("With body: $body");
      
      final response = await http.post(url, headers: headers, body: body);
      
      // Print API response in terminal for debugging
      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Star details API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final star = Star.fromJson(data);
        debugPrint("Successfully parsed star: ${star.name}");
        return star;
      } else {
        throw Exception("Failed to load star details. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("===== ERROR FETCHING STAR DETAILS =====");
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Add to favorites functionality could be added here similar to planets
}
