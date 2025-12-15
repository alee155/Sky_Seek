import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_seek/Auth/login_screen.dart';
import 'package:sky_seek/models/profile_model.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/services/profile_service.dart';
import 'package:sky_seek/services/update_profile_service.dart';
import 'package:sky_seek/utils/snackbar_helper.dart';

class ProfileController extends GetxController {
  var profile = Rxn<ProfileModel>();
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var isRefreshing = false.obs;

  Future<void> loadProfile(String token) async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final result = await ProfileService.getProfile(token);
      if (result != null) {
        profile.value = result;
      } else {
        hasError.value = true;
        errorMessage.value = 'Could not load user profile';
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showError(context, 'Could not load user profile');
        }
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      final context = Get.context;
      if (context != null) {
        SnackbarHelper.showError(context, 'Error loading profile');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile(String token) async {
    isRefreshing.value = true;
    hasError.value = false;

    try {
      final result = await ProfileService.fetchProfileFromApi(token);
      if (result != null) {
        profile.value = result;
      } else {
        hasError.value = true;
        errorMessage.value = 'Could not refresh profile';
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showError(context, 'Could not refresh profile');
        }
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      final context = Get.context;
      if (context != null) {
        SnackbarHelper.showError(context, 'Error refreshing profile');
      }
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<bool> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String gender,
  }) async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final result = await UpdateProfileService.updateProfile(
        token: token,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
      );

      if (result['success'] == true && result['profile'] != null) {
        profile.value = result['profile'] as ProfileModel;
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showProfileUpdate(context);
        }
        return true;
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to update profile';
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showError(context, 'Failed to update profile');
        }
        return false;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      final context = Get.context;
      if (context != null) {
        SnackbarHelper.showError(context, 'Error updating profile');
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    Get.offAll(() => const LoginScreen());
  }
}
