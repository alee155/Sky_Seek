import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/Auth/login_screen.dart';
import 'package:sky_seek/controller/signup_controller.dart';
import 'package:sky_seek/widgets/custom_dropdown_field.dart';
import 'package:sky_seek/widgets/custom_textfield_widget.dart';
import 'package:sky_seek/widgets/earth_loader.dart';
import 'package:sky_seek/widgets/gradient_button_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/splash.png', fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.5)),
              ],
            ),
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
            top: 150.h,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Image.asset(
                    'assets/images/SkySeek.png',
                    width: 187.w,
                    height: 56.h,
                  ),
                  Text(
                    "Lets Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    controller: controller.firstNameController,
                    hintText: 'First Name',
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: controller.lastNameController,
                    hintText: 'Last Name',
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: controller.emailController,
                    hintText: 'Email',
                    onChanged: (value) {
                      controller.validateEmail(value);
                    },
                  ),
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.only(left: 8.w, top: 4.h),
                      child:
                          controller.showEmailError.value
                              ? Text(
                                "Please enter a valid email",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                ),
                              )
                              : const SizedBox.shrink(),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GetBuilder<SignupController>(
                    id: 'gender_dropdown',
                    builder: (_) {
                      return CustomDropdownField(
                        key: ValueKey(
                          'gender_dropdown_${controller.selectedGender.value}',
                        ),
                        selectedValue: controller.selectedGender.value,
                        items: ['Male', 'Female'],
                        hintText: 'Select Gender',
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedGender.value = value;
                            controller.update(['gender_dropdown']);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: controller.passwordController,
                    hintText: 'Password',
                    isPassword: true,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: controller.confirmPasswordController,
                    hintText: 'Confirm Password',
                    isPassword: true,
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: Obx(() {
                      return controller.isLoading.value
                          ? const EarthLoader(size: 60)
                          : SignupButton(
                            onTap: () {
                              controller.signupUser();
                            },
                          );
                    }),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const LoginScreen(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have account? ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "Sign in",
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
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
