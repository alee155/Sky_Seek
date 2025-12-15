import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_seek/models/login_model.dart';
import 'package:sky_seek/screens/BottomNavBar/bottomnavbar_screen.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/services/login_service.dart';
import 'package:sky_seek/utils/snackbar_helper.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  void loginUser() async {
    isLoading.value = true;
    // Validate
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      final context = Get.context;
      if (context != null) {
        SnackbarHelper.showValidationError(context, 'Email and password');
      }
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
        final userId = decoded['userId'] ?? '';
        final userName = decoded['firstName'] ?? 'User';

        await AuthService.saveToken(token);
        if (userId.isNotEmpty) {
          await AuthService.saveUserId(userId);
        }

        Get.offAll(() => BottomNavScreen(token: token));

        await Future.delayed(const Duration(milliseconds: 300));
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showWelcome(context, userName);
        }
      } else {
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showError(context, msg);
        }
      }
    } catch (e) {
      final context = Get.context;
      if (context != null) {
        SnackbarHelper.showError(context, 'Login failed. Please try again.');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
