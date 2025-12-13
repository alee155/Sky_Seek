import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'package:sky_seek/controller/profile_controller.dart';

import 'package:sky_seek/widgets/cosmic_particle_background.dart';

import 'package:sky_seek/widgets/home_dashboard_section.dart';
import 'package:sky_seek/widgets/marquee_banner.dart';
import 'package:sky_seek/widgets/shooting_star.dart';
import 'package:sky_seek/widgets/star_background.dart';

class HomeScreen extends StatefulWidget {
  final String? token;

  const HomeScreen({super.key, this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    try {
      if (widget.token != null && widget.token!.isNotEmpty) {
        await profileController.loadProfile(widget.token!);
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/homescreen.png',
              fit: BoxFit.cover,
            ),
          ),

          StarBackground(starCount: 150, opacity: 0.7),
          CosmicParticleBackground(
            particleCount: 50,
            opacity: 1,
            colors: const [Colors.teal, Colors.blue, Colors.purple],
          ),
          ShootingStarField(starCount: 30, opacity: 0.8),

          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            child: MarqueeBanner(
                  text: '🌙 Moon is Natural Satellite of Earth 🌏 ',
                )
                .animate()
                .fade(duration: 500.ms)
                .slideY(begin: 1.0, duration: 500.ms, curve: Curves.easeOut),
          ),

          Positioned(
            left: 20.w,
            right: 10.w,
            top: 60.h,
            child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          String greeting;
                          if (profileController.isLoading.value) {
                            greeting = "Loading profile...";
                          } else if (profileController.hasError.value) {
                            greeting = "Hey Explorer,";
                          } else if (profileController.profile.value != null) {
                            greeting =
                                "Hey ${profileController.profile.value!.firstName},";
                          } else {
                            greeting = "Hey there,";
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                greeting,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.tealAccent.withOpacity(0.5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              if (profileController.hasError.value)
                                Text(
                                  "(Offline Mode)",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12.sp,
                                    fontFamily: 'SpaceGrotesk',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              SizedBox(height: 4.h),
                              Text(
                                "You are on Earth",
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 14.sp,
                                  fontFamily: 'SpaceGrotesk',
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),

                    Container(
                      width: 54.w,
                      height: 54.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.tealAccent, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.tealAccent.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(2.w),
                      child: CircleAvatar(
                        radius: 42.r,
                        backgroundColor: Colors.black.withOpacity(0.3),
                        backgroundImage: AssetImage(
                          (profileController.profile.value != null &&
                                  profileController.profile.value!.gender
                                          .toLowerCase() ==
                                      'female')
                              ? 'assets/images/female.png'
                              : 'assets/images/male.png',
                        ),
                      ),
                    ),
                  ],
                )
                .animate()
                .fade(duration: 500.ms)
                .slideY(begin: -1.0, duration: 500.ms, curve: Curves.easeOut),
          ),
          Positioned(
            top: 220.h,
            left: 20.w,
            right: 20.w,
            child: HomeDashboardSection(token: widget.token),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 5.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.tealAccent.withOpacity(0.5),
                    Colors.tealAccent.withOpacity(0.8),
                    Colors.tealAccent.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
