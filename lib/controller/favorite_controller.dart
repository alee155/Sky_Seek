import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sky_seek/models/planet_model.dart';
import 'package:sky_seek/services/planet_service.dart';

class FavoriteController extends GetxController {
  var favoritePlanets = <Planet>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  /// Load favorite planets from API
  Future<void> loadFavoritePlanets(String token) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      final result = await PlanetService.getFavoritePlanets(token);
      
      if (result.isEmpty) {
        debugPrint('No favorite planets found');
      } else {
        debugPrint('Loaded ${result.length} favorite planets');
      }
      
      favoritePlanets.assignAll(result);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error loading favorite planets: $e';
      debugPrint('Error in loadFavoritePlanets: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Remove a planet from favorites
  Future<Map<String, dynamic>> removeFavorite(String token, String planetId) async {
    try {
      isLoading.value = true;
      
      // Call the API to remove the planet from favorites
      final result = await PlanetService.removeFavorite(token, planetId);
      
      if (result['success'] == true) {
        // Remove the planet from the local list
        favoritePlanets.removeWhere((planet) => planet.id == planetId);
        debugPrint('Successfully removed planet $planetId from favorites');
      } else {
        debugPrint('Failed to remove planet from favorites: ${result['message']}');
      }
      
      return result;
    } catch (e) {
      debugPrint('Error in removeFavorite: $e');
      return {
        "success": false,
        "message": "Error removing planet from favorites: $e",
        "data": null
      };
    } finally {
      isLoading.value = false;
    }
  }
}
