import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_seek/models/planet_model.dart';
import 'package:sky_seek/services/planet_service.dart';
import 'package:sky_seek/utils/snackbar_helper.dart';

class PlanetController extends GetxController {
  var planets = <Planet>[].obs;
  var isLoading = true.obs;
  var currentPlanetIndex = 0.obs;
  var isFavoriting = false.obs; // Track favorite API call status
  @override
  void onInit() {
    fetchPlanets();
    super.onInit();
  }

  void nextPlanet() {
    if (currentPlanetIndex.value < planets.length - 1) {
      currentPlanetIndex++;
    }
  }

  void previousPlanet() {
    if (currentPlanetIndex.value > 0) {
      currentPlanetIndex--;
    }
  }

  // Get the numeric position of a planet from its position string (e.g., "1st planet" -> 1)
  int _getPlanetOrderNumber(String position) {
    // Extract just the number from the position string
    final positionRegex = RegExp(r'(\d+)');
    final match = positionRegex.firstMatch(position);
    if (match != null) {
      return int.tryParse(match.group(0) ?? '0') ?? 0;
    }
    return 0; // Default if no match found
  }

  /// Add current planet to favorites
  Future<void> addToFavorite(String token) async {
    if (planets.isEmpty || isFavoriting.value) return;

    try {
      isFavoriting(true);
      final currentPlanet = planets[currentPlanetIndex.value];

      // Call the service method
      final result = await PlanetService.addToFavorite(token, currentPlanet.id);

      // Check if the message contains "already in favorites"
      if (!result['success'] &&
          (result['message'].toString().contains("already in favorites") ||
              (result['data'] != null &&
                  result['data']['msg'].toString().contains(
                    "already in favorites",
                  )))) {
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showWarning(context, 'Planet already in favorites');
        }
        return;
      }

      // Show message based on result
      final context = Get.context;
      if (context != null) {
        if (result['success']) {
          SnackbarHelper.showSuccess(context, result['message']);
        } else {
          SnackbarHelper.showError(context, result['message']);
        }
      }
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      final context = Get.context;
      if (context != null) {
        SnackbarHelper.showError(context, 'Failed to add planet to favorites');
      }
    } finally {
      isFavoriting(false);
    }
  }

  void fetchPlanets() async {
    try {
      isLoading(true);
      final result = await PlanetService.fetchPlanets();

      // Sort planets by their position in the solar system
      result.sort((a, b) {
        int positionA = _getPlanetOrderNumber(a.position);
        int positionB = _getPlanetOrderNumber(b.position);
        return positionA.compareTo(positionB);
      });

      planets.assignAll(result);
      print("Fetched Planets: ${result.length}");
      for (var planet in result) {
        print("============================");
        print("ID: ${planet.id}");
        print("Name: ${planet.name}");
        print("Image: ${planet.image}");
        print("Type: ${planet.type}");
        print("Symbol: ${planet.symbol}");
        print("Position: ${planet.position}");
        print("Diameter: ${planet.diameter}");
        print("Mass: ${planet.mass}");
        print("Gravity: ${planet.gravity}");
        print("Rotation Period: ${planet.rotationPeriod}");
        print("Solar Day: ${planet.solarDay}");
        print("Orbital Period: ${planet.orbitalPeriod}");
        print("Orbital Speed: ${planet.orbitalSpeed}");
        print("Moons: ${planet.moons}");
        print("Atmosphere Composition: ${planet.atmosphereComposition}");
        print("Atmosphere Pressure: ${planet.atmospherePressure}");
        print("Temperature Min: ${planet.temperatureMin}");
        print("Temperature Max: ${planet.temperatureMax}");
        print("Distance from Sun: ${planet.distanceFromSun}");
        print("Eccentricity: ${planet.eccentricity}");
        print("Rings: ${planet.rings}");
        print("Magnetic Field: ${planet.magneticField}");
        print("Surface: ${planet.surface}");
        print("Trivia: ${planet.trivia}");
        print("Supports Life: ${planet.supportsLife}");
        print("============================\n");
      }
    } catch (e) {
      print("Error fetching planets: $e");
    } finally {
      isLoading(false);
    }
  }
}
