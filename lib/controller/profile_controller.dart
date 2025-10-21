import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_seek/Auth/login_screen.dart';
import 'package:sky_seek/models/profile_model.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/services/profile_service.dart';
import 'package:sky_seek/services/update_profile_service.dart';

class ProfileController extends GetxController {
  var profile = Rxn<ProfileModel>();
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var isRefreshing = false.obs; // To track manual refresh operations

  /// Load profile data - first tries local cache, then API if necessary
  Future<void> loadProfile(String token) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // Get profile, preferring cached version if available
      final result = await ProfileService.getProfile(token);
      if (result != null) {
        profile.value = result;
        debugPrint(
          'Profile loaded successfully: ${result.firstName} ${result.lastName}',
        );
      } else {
        hasError.value = true;
        errorMessage.value = 'Could not load user profile';
        debugPrint('Profile result was null');
        debugPrint('Token used: $token');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error loading profile: $e';
      debugPrint('Error in loadProfile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Force refresh profile data from API
  Future<void> refreshProfile(String token) async {
    isRefreshing.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // Explicitly fetch from API, bypassing cache
      final result = await ProfileService.fetchProfileFromApi(token);
      if (result != null) {
        profile.value = result;
        // Removed the success snackbar message
        debugPrint(
          'Profile refreshed from API: ${result.firstName} ${result.lastName}',
        );
      } else {
        hasError.value = true;
        errorMessage.value = 'Could not refresh profile data';
        debugPrint('Profile refresh result was null');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error refreshing profile: $e';
      debugPrint('Error in refreshProfile: $e');
      Get.snackbar(
        'Error',
        'Failed to refresh profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Update the user's profile information
  Future<bool> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String gender,
    Map<String, dynamic>?
    rawResponse, // Added to store raw response for debugging
  }) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final result = await UpdateProfileService.updateProfile(
        token: token,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
      );

      if (result['success'] == true && result['profile'] != null) {
        // Cast to ProfileModel
        final updatedProfile = result['profile'] as ProfileModel;
        profile.value = updatedProfile;

        // Get result info for debugging only
        debugPrint('Status code: ${result['statusCode']}');
        debugPrint('Raw response: ${result['rawResponse']}');

        // Show simple success message
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: EdgeInsets.all(10),
        );

        debugPrint('Profile updated successfully with data:');
        debugPrint('First Name: ${updatedProfile.firstName}');
        debugPrint('Last Name: ${updatedProfile.lastName}');
        debugPrint('Gender: ${updatedProfile.gender}');
        return true;
      } else {
        hasError.value = true;
        // Log error details for debugging
        debugPrint('Status code: ${result['statusCode']}');
        debugPrint('Raw response: ${result['rawResponse']}');

        errorMessage.value = 'Failed to update profile';
        Get.snackbar(
          'Error',
          'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: EdgeInsets.all(10),
        );
        return false;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error updating profile: $e';
      debugPrint('Error in updateProfile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    // Clear auth data using AuthService
    await AuthService.logout();

    // Navigate to login screen and clear navigation stack
    Get.offAll(() => const LoginScreen());
  }
}
