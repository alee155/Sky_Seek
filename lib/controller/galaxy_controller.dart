import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sky_seek/models/galaxy_model.dart';
import 'package:sky_seek/services/galaxy_service.dart';

class GalaxyController extends GetxController {
  // Observable states
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final galaxies = <Galaxy>[].obs;
  final selectedGalaxy = Rxn<Galaxy>();
  
  // Current token for authentication
  String? _token;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize with empty state
    isLoading.value = false;
    hasError.value = false;
    errorMessage.value = '';
    debugPrint("GalaxyController initialized");
  }
  
  // Set token from outside
  void setToken(String token) {
    if (token.isNotEmpty) {
      _token = token;
      debugPrint("Token set in GalaxyController");
    }
  }

  // Load galaxies from API with safe state management
  Future<void> loadGalaxies(String token) async {
    if (token.isEmpty) {
      Future.microtask(() {
        hasError(true);
        errorMessage('Authentication token is empty');
      });
      return;
    }
    
    try {
      // Set loading state
      isLoading(true);
      hasError(false);
      errorMessage('');
      _token = token;

      // Fetch galaxies from API
      final galaxiesList = await GalaxyService.fetchGalaxies(token);
      
      // Update galaxies list
      galaxies.clear();
      galaxies.addAll(galaxiesList);
      
      debugPrint("Loaded ${galaxies.length} galaxies");
    } catch (e) {
      hasError(true);
      errorMessage(e.toString());
      debugPrint("Error loading galaxies: $e");
    } finally {
      isLoading(false);
    }
  }
  
  // Prepare to load galaxy details without immediately updating state
  void prepareGalaxyDetails(String galaxyId) {
    isLoading(true);
    hasError(false);
    errorMessage('');
    
    // Check if token is available
    if (_token == null || _token!.isEmpty) {
      // Schedule state update for next frame
      debugPrint("Error: No token available for galaxy details");
      Future.microtask(() {
        hasError(true);
        errorMessage('Authentication token not available. Please return to the galaxies list.');
        isLoading(false);
      });
      return;
    }
    
    debugPrint("Preparing to load galaxy details for ID: $galaxyId with token available");
    
    // Find galaxy in current list first
    Galaxy? galaxy = galaxies.firstWhereOrNull((g) => g.id == galaxyId);
    
    if (galaxy != null) {
      // Use microtask to avoid updating state during build
      Future.microtask(() {
        selectedGalaxy.value = galaxy;
        isLoading(false);
      });
    } else {
      // Schedule API call for next frame
      Future.microtask(() => _fetchGalaxyDetailsFromAPI(galaxyId));
    }
  }
  
  // Actual API call function that's called after the current build phase
  Future<void> _fetchGalaxyDetailsFromAPI(String galaxyId) async {
    try {
      final galaxyDetails = await GalaxyService.fetchGalaxyDetails(_token!, galaxyId);
      selectedGalaxy.value = galaxyDetails;
    } catch (e) {
      hasError(true);
      errorMessage(e.toString());
      debugPrint("Error loading galaxy details: $e");
    } finally {
      isLoading(false);
    }
  }
  
  // Keep for compatibility - delegates to the new approach
  Future<void> loadGalaxyDetails(String galaxyId) async {
    prepareGalaxyDetails(galaxyId);
  }
  
  // Clear selected galaxy when leaving details screen
  void clearSelectedGalaxy() {
    selectedGalaxy.value = null;
  }
}
