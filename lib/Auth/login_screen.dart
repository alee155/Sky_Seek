import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/Auth/signup_screen.dart';
import 'package:sky_seek/controller/login_controller.dart';
import 'package:sky_seek/widgets/custom_textfield_widget.dart';
import 'package:sky_seek/widgets/earth_loader.dart';
import 'package:sky_seek/widgets/gradient_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/images/Login.png', fit: BoxFit.cover),
          ),
          Positioned(
            top: 20.h,
            right: 0.w,
            child: Image.asset(
              'assets/images/satalight.png',
              width: 150.w,
              height: 150.h,
            ),
          ),
          Positioned.fill(
            top: 140.h,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/SkySeek.png',
                    width: 187.w,
                    height: 56.h,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Get Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  CustomTextField(
                    controller: controller.emailController,
                    hintText: 'Email',
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: controller.passwordController,
                    hintText: 'Password',
                    isPassword: true,
                  ),
                  SizedBox(height: 30.h),
                  Center(
                    child: Obx(() {
                      return controller.isLoading.value
                          ? const EarthLoader(size: 60)
                          : LoginButton(
                            onTap: () {
                              controller.loginUser();
                            },
                          );
                    }),
                  ),
                  SizedBox(height: 20.h),

                  // ✅ Terms and Conditions Section
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                          ),
                          children: [
                            const TextSpan(
                              text: "By logging in, you agree to our ",
                            ),
                            TextSpan(
                              text: "Terms & Conditions",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () async {
                                      final Uri url = Uri.parse(
                                        'https://skyseek.dgexpense.com/terms&conditions',
                                      );
                                      if (!await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      )) {
                                        throw 'Could not launch $url';
                                      }
                                    },
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () async {
                                      final Uri url = Uri.parse(
                                        'https://skyseek.dgexpense.com/privacy_policy',
                                      );
                                      if (!await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      )) {
                                        throw 'Could not launch $url';
                                      }
                                    },
                            ),
                            const TextSpan(text: "."),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const SignupScreen(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don’t have account? ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
