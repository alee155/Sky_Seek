import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Safe navigation helper to avoid GetX snackbar controller errors
class NavigationHelper {
  /// Safely go back, avoiding GetX snackbar controller initialization errors
  static void goBack(BuildContext context) {
    // Close any open snackbars first
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    // Use Navigator instead of Get.back() to avoid snackbar controller issues
    Navigator.of(context).pop();
  }

  /// Alternative: Use Get.back() with error handling
  static void goBackWithGet() {
    try {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.back();
    } catch (e) {
      // Fallback if Get.back() fails
      if (Get.context != null) {
        Navigator.of(Get.context!).pop();
      }
    }
  }
}
