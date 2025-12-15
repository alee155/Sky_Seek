import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/config/api_config.dart';
import 'package:sky_seek/widgets/earth_loader.dart';
import 'package:sky_seek/utils/snackbar_helper.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> updatePassword() async {
    if (_passwordController.text.isEmpty) {
      SnackbarHelper.showValidationError(context, 'New password');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      SnackbarHelper.showError(context, 'Passwords do not match');
      return;
    }

    if (_passwordController.text.length < 6) {
      SnackbarHelper.showError(
        context,
        'Password must be at least 6 characters long',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? token = await AuthService.getToken();
      if (token == null) {
        SnackbarHelper.showError(
          context,
          'Authentication token not found. Please log in again.',
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final String updatePasswordEndpoint = ApiConfig.updatePasswordEndpoint;

      final response = await http.patch(
        Uri.parse(updatePasswordEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'newPassword': _passwordController.text}),
      );

      print(
        "Password Update Response: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 200) {
        SnackbarHelper.showSuccess(context, 'Password updated successfully');
        _passwordController.clear();
        _confirmPasswordController.clear();

        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        var responseBody = jsonDecode(response.body);
        var errorMsg = responseBody['msg'] ?? "Failed to update password";

        SnackbarHelper.showError(context, errorMsg);
      }
    } catch (e) {
      print("Password Update Error: $e");
      SnackbarHelper.showError(
        context,
        'An error occurred while updating password',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Update Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/profile.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  color: Colors.black.withOpacity(0.4),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      'Create New Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Please enter and confirm your new password',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                    SizedBox(height: 40.h),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'New Password',
                          hintStyle: TextStyle(color: Colors.white54),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 15.h,
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Confirm New Password',
                          hintStyle: TextStyle(color: Colors.white54),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 15.h,
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),

                    SizedBox(
                      width: double.infinity,
                      height: _isLoading ? 90.h : null,
                      child:
                          _isLoading
                              ? Center(child: EarthLoader(size: 60))
                              : ElevatedButton(
                                onPressed: updatePassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyanAccent,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(vertical: 15.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                                child: Text(
                                  'Update Password',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
