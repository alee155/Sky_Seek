import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_seek/models/login_model.dart';
import 'package:sky_seek/screens/BottomNavBar/bottomnavbar_screen.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/services/login_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  void loginUser() async {
    isLoading.value = true;
    // Validate
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Email and password are required.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return;
    }

    LoginModel model = LoginModel(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    try {
      final response = await LoginService.login(model);
      print("Login Response: ${response.statusCode} - ${response.body}");

      final decoded = jsonDecode(response.body);
      final msg = decoded['msg'] ?? 'Welcome to SkySeek';

      if (response.statusCode == 200) {
        final token = decoded['token'];
        final userId = decoded['userId'] ?? ''; // Get user ID if available
        
        // Save token and user ID using AuthService
        await AuthService.saveToken(token);
        if (userId.isNotEmpty) {
          await AuthService.saveUserId(userId);
        }
        
        Get.snackbar(
          "Success",
          msg,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        await Future.delayed(Duration(milliseconds: 500));
        Get.offAll(() => BottomNavScreen(token: token));
      } else {
        Get.snackbar(
          "Login Failed",
          msg,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Login Error: $e");
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
