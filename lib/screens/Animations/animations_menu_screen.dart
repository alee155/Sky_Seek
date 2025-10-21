import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/screens/Animations/day_night_cycle.dart';
import 'package:sky_seek/screens/Animations/earth_moon_animation.dart';
import 'package:sky_seek/screens/Animations/solar_system_animation.dart';
import 'package:sky_seek/screens/Animations/star_field_animation.dart';
import 'package:sky_seek/widgets/cosmic_particle_background.dart';
import 'package:sky_seek/widgets/star_background.dart';

class AnimationsMenuScreen extends StatefulWidget {
  const AnimationsMenuScreen({super.key});

  @override
  State<AnimationsMenuScreen> createState() => _AnimationsMenuScreenState();
}

class _AnimationsMenuScreenState extends State<AnimationsMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
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
          'Space Animations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background effects
          SizedBox.expand(
            child: Image.asset(
              'assets/images/homescreen.png',
              fit: BoxFit.cover,
            ),
          ),
          Opacity(opacity: 0.7, child: StarBackground(starCount: 150)),
          Opacity(
            opacity: 0.4,
            child: CosmicParticleBackground(
              particleCount: 20,
              colors: const [
                Colors.tealAccent,
                Colors.blueAccent,
                Colors.purpleAccent,
              ],
            ),
          ),

          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeController,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'Explore Cosmic Animations',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Tap to experience interactive space simulations',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20.h,
                        crossAxisSpacing: 20.w,
                        children: [
                          _buildAnimationCard(
                            title: 'Earth & Moon',
                            description: 'Rotation simulation',
                            icon: Icons.public,
                            gradient: const [
                              Color(0xFF0A4DA2),
                              Color(0xFF0F2B61),
                            ],
                            onTap:
                                () => Get.to(
                                  () => const EarthMoonAnimation(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 500),
                                ),
                          ),
                          _buildAnimationCard(
                            title: 'Solar System',
                            description: 'Planetary orbits',
                            icon: Icons.wb_sunny_rounded,
                            gradient: const [
                              Color(0xFF6A1B9A),
                              Color(0xFF4A148C),
                            ],
                            onTap:
                                () => Get.to(
                                  () => const SolarSystemAnimation(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 500),
                                ),
                          ),
                          // _buildAnimationCard(
                          //   title: 'Day & Night',
                          //   description: 'Earth rotation cycle',
                          //   icon: Icons.nightlight_round,
                          //   gradient: const [
                          //     Color(0xFF00695C),
                          //     Color(0xFF004D40),
                          //   ],
                          //   onTap: () => Get.to(() => EarthDayNightCycle()),
                          // ),
                          _buildAnimationCard(
                            title: 'Star Field',
                            description: 'Interactive stargazing',
                            icon: Icons.auto_awesome,
                            gradient: const [
                              Color(0xFF880E4F),
                              Color(0xFF560027),
                            ],
                            onTap:
                                () => Get.to(
                                  () => const StarFieldAnimation(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 500),
                                ),
                          ),
                        ],
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

  Widget _buildAnimationCard({
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40.sp),
              SizedBox(height: 15.h),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
