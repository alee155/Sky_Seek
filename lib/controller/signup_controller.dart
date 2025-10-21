import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_seek/Auth/login_screen.dart';
import 'package:sky_seek/models/signup_model.dart';
import 'package:sky_seek/screens/BottomNavBar/bottomnavbar_screen.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/services/signup_service.dart';

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
    // Input validation
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        selectedGender.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please fill in all the fields.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return;
    }

    // Check email validation
    final email = emailController.text.trim();
    validateEmail(email);
    
    if (!isEmailValid.value) {
      Get.snackbar(
        "Invalid Email",
        "Please enter a valid email address.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Password Mismatch",
        "Password and Confirm Password do not match.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
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
        // Check if token is provided in the response
        final token = decoded['token'];
        final userId = decoded['userId'] ?? '';

        if (token != null) {
          // Save token and user ID using AuthService
          await AuthService.saveToken(token);
          if (userId.isNotEmpty) {
            await AuthService.saveUserId(userId);
          }

          Get.snackbar(
            "Success",
            "Redirecting to home screen...",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          await Future.delayed(Duration(milliseconds: 500));
          Get.offAll(
            () => BottomNavScreen(token: token),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500),
          );
        } else {
          Get.snackbar(
            "Success",
            "Please login to continue.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          await Future.delayed(Duration(milliseconds: 500));
          Get.offAll(
            () => const LoginScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500),
          );
        }
      } else {
        Get.snackbar(
          "Signup Failed",
          msg,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Signup Error: $e");
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
