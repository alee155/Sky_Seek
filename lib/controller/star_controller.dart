import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sky_seek/models/star_model.dart';
import 'package:sky_seek/services/star_service.dart';

class StarController extends GetxController {
  // Observable states
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final stars = <Star>[].obs;
  final selectedStar = Rxn<Star>();
  
  // Current token for authentication
  String? _token;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize with empty state
    isLoading.value = false;
    hasError.value = false;
    errorMessage.value = '';
    debugPrint("StarController initialized");
  }
  
  // Set token from outside
  void setToken(String token) {
    if (token.isNotEmpty) {
      _token = token;
      debugPrint("Token set in StarController");
    }
  }

  // Load stars from API
  Future<void> loadStars(String token) async {
    if (token.isEmpty) {
      hasError(true);
      errorMessage('Authentication token is empty');
      return;
    }
    
    try {
      // Set loading state
      isLoading(true);
      hasError(false);
      errorMessage('');
      _token = token;

      // Fetch stars from API
      final starsList = await StarService.fetchStars(token);
      
      // Update stars list
      stars.clear();
      stars.addAll(starsList);
      
      debugPrint("Loaded ${stars.length} stars");
    } catch (e) {
      hasError(true);
      errorMessage(e.toString());
      debugPrint("Error loading stars: $e");
    } finally {
      isLoading(false);
    }
  }
  
  // Prepare to load star details without immediately updating state
  void prepareStarDetails(String starId) {
    isLoading(true);
    hasError(false);
    errorMessage('');
    
    // Check if token is available
    if (_token == null || _token!.isEmpty) {
      // Schedule state update for next frame
      debugPrint("Error: No token available for star details");
      Future.microtask(() {
        hasError(true);
        errorMessage('Authentication token not available. Please return to the stars list.');
        isLoading(false);
      });
      return;
    }
    
    debugPrint("Preparing to load star details for ID: $starId with token available");
    
    // Find star in current list first
    Star? star = stars.firstWhereOrNull((s) => s.id == starId);
    
    if (star != null) {
      // Use microtask to avoid updating state during build
      Future.microtask(() {
        selectedStar.value = star;
        isLoading(false);
      });
    } else {
      // Schedule API call for next frame
      Future.microtask(() => _fetchStarDetailsFromAPI(starId));
    }
  }
  
  // Actual API call function that's called after the current build phase
  Future<void> _fetchStarDetailsFromAPI(String starId) async {
    try {
      final starDetails = await StarService.fetchStarDetails(_token!, starId);
      selectedStar.value = starDetails;
    } catch (e) {
      hasError(true);
      errorMessage(e.toString());
      debugPrint("Error loading star details: $e");
    } finally {
      isLoading(false);
    }
  }
  
  // Keep for compatibility - delegates to the new approach
  Future<void> loadStarDetails(String starId) async {
    prepareStarDetails(starId);
  }
  
  // Clear selected star when leaving details screen
  void clearSelectedStar() {
    selectedStar.value = null;
  }
}
