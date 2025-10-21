import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sky_seek/screens/NewPassword/new_password_screen.dart';
import 'package:sky_seek/screens/SettingsScreen/about_us_screen.dart';
import 'package:sky_seek/screens/ProfileScreen/edit_profile_screen.dart';
import 'package:sky_seek/screens/AccountScreen/delete_account_screen.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/profile_controller.dart';
import 'package:sky_seek/screens/SettingsScreen/privacy_policy_screen.dart';
import 'package:sky_seek/screens/SettingsScreen/terms_and_conditions_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  final ProfileController controller = Get.put(ProfileController());

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 🔹 Animated Setting Tile
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required int index,
  }) {
    final start = index * 0.1;
    final end = start + 0.4;
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(curved),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white12),
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.cyanAccent, size: 22.sp),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16.sp,
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
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
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/profile.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            _buildSettingTile(
                              icon: Icons.edit,
                              title: "Edit Profile",
                              onTap: () {
                                Get.to(
                                  () => const EditProfileScreen(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              index: 0,
                            ),
                            _buildSettingTile(
                              icon: Icons.lock,
                              title: "Edit Password",
                              onTap: () {
                                Get.to(
                                  () => const NewPasswordScreen(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              index: 1,
                            ),
                            _buildSettingTile(
                              icon: Icons.delete_forever,
                              title: "Delete Account",
                              onTap: () {
                                Get.to(
                                  () => const DeleteAccountScreen(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              index: 2,
                            ),
                            _buildSettingTile(
                              icon: Icons.privacy_tip,
                              title: "Privacy & Policy",
                              onTap: () {
                                Get.to(
                                  () => const PrivacyPolicyScreen(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              index: 3,
                            ),
                            _buildSettingTile(
                              icon: Icons.privacy_tip,
                              title: "Terms & Conditions",
                              onTap: () {
                                Get.to(
                                  () => const TermsAndConditionsScreen(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              index: 4,
                            ),
                            _buildSettingTile(
                              icon: Icons.person_2,
                              title: "About Us",
                              onTap: () {
                                Get.to(
                                  () => const AboutUsScreen(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              index: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
