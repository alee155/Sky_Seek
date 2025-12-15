import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_seek/Auth/login_screen.dart';
import 'package:sky_seek/models/signup_model.dart';
import 'package:sky_seek/screens/BottomNavBar/bottomnavbar_screen.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/services/signup_service.dart';
import 'package:sky_seek/utils/snackbar_helper.dart';

class SignupController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var selectedGender = "".obs;
  final isLoading = false.obs;
  final isEmailValid = true.obs;
  final showEmailError = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Listen for email changes to provide real-time validation
    emailController.addListener(() {
      validateEmail(emailController.text);
    });
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Email validation regular expression
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    caseSensitive: false,
    multiLine: false,
  );

  // Validate email format
  bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  // Validate email and update the error state
  void validateEmail(String email) {
    if (email.isEmpty) {
      showEmailError.value = false;
      isEmailValid.value = true; // Don't show error for empty field
    } else {
      isEmailValid.value = isValidEmail(email);
      showEmailError.value = !isEmailValid.value;
    }
  }

  // Update gender selection with debug print
  void updateGender(String? gender) {
    if (gender != null && gender.isNotEmpty) {
      selectedGender.value = gender;
      print('Gender updated to: ${selectedGender.value}');
    }
  }

  void signupUser() async {
    isLoading.value = true;
    final context = Get.context;

    // Input validation
    if (firstNameController.text.trim().isEmpty) {
      if (context != null) {
        SnackbarHelper.showValidationError(context, 'First name');
      }
      isLoading.value = false;
      return;
    }

    if (lastNameController.text.trim().isEmpty) {
      if (context != null) {
        SnackbarHelper.showValidationError(context, 'Last name');
      }
      isLoading.value = false;
      return;
    }

    if (emailController.text.trim().isEmpty) {
      if (context != null) {
        SnackbarHelper.showValidationError(context, 'Email');
      }
      isLoading.value = false;
      return;
    }

    if (passwordController.text.isEmpty) {
      if (context != null) {
        SnackbarHelper.showValidationError(context, 'Password');
      }
      isLoading.value = false;
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      if (context != null) {
        SnackbarHelper.showValidationError(context, 'Confirm password');
      }
      isLoading.value = false;
      return;
    }

    if (selectedGender.value.isEmpty) {
      if (context != null) {
        SnackbarHelper.showValidationError(context, 'Gender');
      }
      isLoading.value = false;
      return;
    }

    // Check email validation
    final email = emailController.text.trim();
    validateEmail(email);

    if (!isEmailValid.value) {
      if (context != null) {
        SnackbarHelper.showError(context, 'Please enter a valid email address');
      }
      isLoading.value = false;
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      if (context != null) {
        SnackbarHelper.showError(context, 'Passwords do not match');
      }
      isLoading.value = false;
      return;
    }

    // Prepare model
    SignupModel model = SignupModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      gender: selectedGender.value,
    );

    try {
      final response = await SignupService.signup(model);
      print("Signup Response: ${response.statusCode} - ${response.body}");

      final decoded = jsonDecode(response.body);
      final msg = decoded['msg'] ?? 'Something went wrong';

      if (response.statusCode == 201) {
        final token = decoded['token'];
        final userId = decoded['userId'] ?? '';
        final userName =
            decoded['firstName'] ?? firstNameController.text.trim();

        if (token != null) {
          await AuthService.saveToken(token);
          if (userId.isNotEmpty) {
            await AuthService.saveUserId(userId);
          }

          Get.offAll(
            () => BottomNavScreen(token: token),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500),
          );

          await Future.delayed(const Duration(milliseconds: 300));
          final newContext = Get.context;
          if (newContext != null) {
            SnackbarHelper.showSuccess(
              newContext,
              'Account created successfully! Welcome, $userName! 🎉',
            );
          }
        } else {
          if (context != null) {
            SnackbarHelper.showSuccess(
              context,
              'Account created! Please login to continue.',
            );
          }
          Get.offAll(
            () => const LoginScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500),
          );
        }
      } else {
        if (context != null) {
          SnackbarHelper.showError(context, msg);
        }
      }
    } catch (e) {
      if (context != null) {
        SnackbarHelper.showError(context, 'Signup failed. Please try again.');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
