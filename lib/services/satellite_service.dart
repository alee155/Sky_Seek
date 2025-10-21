import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sky_seek/models/satellite_model.dart';
import 'package:sky_seek/config/api_config.dart';

class SatelliteService {
  static Future<List<Satellite>> fetchSatellites(String token) async {
    debugPrint("===== STARTING SATELLITES FETCH =====");
    
    try {
      final url = Uri.parse(
        ApiConfig.satellitesEndpoint,
      );
      
      // Prepare headers with authentication token
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      debugPrint("Fetching satellites with token: ${token.isNotEmpty ? 'Valid token' : 'Empty token'}");
      debugPrint("Making API call to: ${url.toString()}");
      
      final response = await http.get(url, headers: headers);
      
      // Print API response in terminal for debugging
      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Satellites API Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Debug the response structure
        debugPrint("API Response Structure: ${responseData.runtimeType}");
        
        List satellitesData;
        if (responseData is List) {
          satellitesData = responseData;
          debugPrint("Response is a list with ${satellitesData.length} satellites");
        } else if (responseData is Map && responseData.containsKey('satellites')) {
          satellitesData = responseData['satellites'];
          debugPrint("Response is a map with 'satellites' key, found ${satellitesData.length} satellites");
        } else {
          throw Exception("Unexpected API response format");
        }
        
        final satellites = satellitesData.map((e) => Satellite.fromJson(e)).toList();
        debugPrint("Successfully parsed ${satellites.length} satellites");
        return satellites;
      } else {
        throw Exception("Failed to load satellites. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("===== ERROR FETCHING SATELLITES =====");
      debugPrint(e.toString());
      rethrow;
    }
  }

  static Future<Satellite> fetchSatelliteDetails(String token, String satelliteId) async {
    debugPrint("===== STARTING SATELLITE DETAILS FETCH =====");
    
    try {
      final url = Uri.parse(
        ApiConfig.satelliteDetailsEndpoint,
      );
      
      // Prepare headers with authentication token
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      // Prepare request body with satellite ID
      final body = jsonEncode({"satelliteId": satelliteId});
      
      debugPrint("Making API call to: ${url.toString()}");
      debugPrint("With body: $body");
      
      final response = await http.post(url, headers: headers, body: body);
      
      // Print API response in terminal for debugging
      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Satellite details API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final satellite = Satellite.fromJson(data);
        debugPrint("Successfully parsed satellite: ${satellite.name}");
        return satellite;
      } else {
        throw Exception("Failed to load satellite details. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("===== ERROR FETCHING SATELLITE DETAILS =====");
      debugPrint(e.toString());
      rethrow;
    }
  }
}
