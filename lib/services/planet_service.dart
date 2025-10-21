import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sky_seek/models/planet_model.dart';
import 'package:sky_seek/config/api_config.dart';

class PlanetService {
  static Future<List<Planet>> fetchPlanets() async {
    final url = Uri.parse(
      ApiConfig.planetsEndpoint,
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Planet.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load planets");
    }
  }

  /// Add a planet to favorites
  static Future<Map<String, dynamic>> addToFavorite(
    String token,
    String planetId,
  ) async {
    try {
      final url = Uri.parse(
        ApiConfig.addToFavoritesEndpoint,
      );

      // Prepare headers with authentication token
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      // Prepare request body with planet ID
      final body = jsonEncode({"planetId": planetId});

      debugPrint("Adding planet $planetId to favorites");

      // Make POST request
      final response = await http.post(url, headers: headers, body: body);

      // Parse response
      final responseData = jsonDecode(response.body);
      debugPrint("Add to favorite response: ${response.body}");
      
      // Special handling for "already in favorites" case
      if (responseData != null && responseData["msg"] == "Planet already in favorites") {
        return {
          "success": false,
          "message": "Planet already in favorites",
          "data": responseData,
        };
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message":
              responseData["message"] ??
              "Planet added to favorites successfully",
          "data": responseData,
        };
      } else {
        return {
          "success": false,
          "message":
              responseData["message"] ?? "Failed to add planet to favorites",
          "data": responseData,
        };
      }
    } catch (e) {
      debugPrint("Error adding planet to favorites: $e");
      return {"success": false, "message": "Error: $e", "data": null};
    }
  }

  /// Compare two planets using the API
  static Future<Map<String, dynamic>> comparePlanets(String token, String planet1, String planet2) async {
    try {
      final url = Uri.parse(ApiConfig.comparePlanetsEndpoint);
      
      // Prepare headers with authentication token
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };
      
      // Prepare request body with planet names
      final body = jsonEncode({
        "planet1": planet1,
        "planet2": planet2,
      });
      
      debugPrint("Comparing planets: $planet1 vs $planet2");
      debugPrint("Request body: $body");
      
      // Make POST request
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      
      // Print full response for debugging
      debugPrint("Planet comparison response: ${response.body}");
      
      if (response.statusCode == 200) {
        // Parse response data
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "data": data
        };
      } else {
        debugPrint("Failed to compare planets: ${response.statusCode}");
        debugPrint("Response: ${response.body}");
        return {
          "success": false,
          "error": "Failed to compare planets. Status code: ${response.statusCode}",
          "data": response.body
        };
      }
    } catch (e) {
      debugPrint("Error comparing planets: $e");
      return {
        "success": false,
        "error": "Error: $e",
        "data": null
      };
    }
  }
  
  /// Fetch favorite planets
  static Future<List<Planet>> getFavoritePlanets(String token) async {
    try {
      final url = Uri.parse(
        ApiConfig.getFavoritePlanetsEndpoint,
      );

      // Prepare headers with authentication token
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      debugPrint("Fetching favorite planets with token: $token");

      // Make GET request
      final response = await http.get(url, headers: headers);

      // Print full response for debugging
      debugPrint("Favorite planets response: ${response.body}");

      if (response.statusCode == 200) {
        // Parse response data
        final data = jsonDecode(response.body);

        // Handle the response structure properly
        List planetsList = [];

        // Check for the 'favorites' key in the response
        if (data is Map &&
            data.containsKey('favorites') &&
            data['favorites'] is List) {
          planetsList = data['favorites'];
          debugPrint(
            "Found ${planetsList.length} favorite planets in response",
          );
        } else if (data is List) {
          // Fallback for direct list format
          planetsList = data;
          debugPrint(
            "Found ${planetsList.length} favorite planets in response (list format)",
          );
        } else {
          debugPrint(
            "Response doesn't contain 'favorites' array or is not a list: $data",
          );
          return [];
        }

        // Convert to Planet objects
        if (planetsList.isNotEmpty) {
          try {
            final planets =
                planetsList.map((item) => Planet.fromJson(item)).toList();
            debugPrint(
              "Successfully parsed ${planets.length} favorite planets",
            );
            return planets;
          } catch (e) {
            debugPrint("Error parsing planet data: $e");
            return [];
          }
        } else {
          debugPrint("No favorite planets found in the response");
          return [];
        }
      } else {
        debugPrint("Failed to fetch favorite planets: ${response.statusCode}");
        debugPrint("Response: ${response.body}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching favorite planets: $e");
      return [];
    }
  }

  /// Remove a planet from favorites
  static Future<Map<String, dynamic>> removeFavorite(
    String token,
    String planetId,
  ) async {
    try {
      final url = Uri.parse(
        ApiConfig.removeFavoriteEndpoint,
      );

      // Prepare headers with authentication token
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      // Prepare request body with planet ID
      final body = jsonEncode({"planetId": planetId});

      debugPrint("Removing planet $planetId from favorites");

      // Make POST request
      final response = await http.post(url, headers: headers, body: body);

      // Parse response
      final responseData = jsonDecode(response.body);
      debugPrint("Remove from favorites response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message":
              responseData["message"] ??
              "Planet removed from favorites successfully",
          "data": responseData,
        };
      } else {
        return {
          "success": false,
          "message":
              responseData["message"] ?? "Failed to remove planet from favorites",
          "data": responseData,
        };
      }
    } catch (e) {
      debugPrint("Error removing planet from favorites: $e");
      return {"success": false, "message": "Error: $e", "data": null};
    }
  }
}
