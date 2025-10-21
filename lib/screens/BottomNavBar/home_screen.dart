import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:sky_seek/screens/Animations/animations_menu_screen.dart';
import 'package:sky_seek/screens/Satellite/satellite_screen.dart';
import 'package:sky_seek/controller/profile_controller.dart';
import 'package:sky_seek/screens/Compare/compare_planets_screen.dart';
import 'package:sky_seek/screens/GalaxyDetails/galaxies_list_screen.dart';
import 'package:sky_seek/screens/PlanetDetails/scroll_planets_screen.dart';
import 'package:sky_seek/screens/QuizScreen/quiz_results_list_screen.dart';
import 'package:sky_seek/screens/QuizScreen/quiz_screen_screen.dart';
import 'package:sky_seek/screens/QuizScreen/quiz_type_screen.dart';
import 'package:sky_seek/screens/StarDetails/stars_list_screen.dart';
import 'package:sky_seek/widgets/cosmic_particle_background.dart';
import 'package:sky_seek/widgets/futuristic_dashboard_card.dart';
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

  // Animation controllers
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });
  }

  void _loadUserProfile() async {
    try {
      // Load user profile if token is available
      if (widget.token != null && widget.token!.isNotEmpty) {
        await profileController.loadProfile(widget.token!);
      }
    } catch (e) {
      print('Error loading profile: $e');
      // If profile fails to load, we'll fallback to the default greeting in the UI
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildMarqueeBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      height: 42.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.tealAccent.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.tealAccent.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Marquee(
          text:
              '🔭 New Jupiter moons discovered! • Mars colony project advances • Upcoming meteor shower on Oct 21 • Space tourism tickets now available • New interactive solar system map released ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'SpaceGrotesk',
          ),
          scrollAxis: Axis.horizontal,
          showFadingOnlyWhenScrolling: true,
          crossAxisAlignment: CrossAxisAlignment.center,
          blankSpace: 80.0,
          velocity: 35.0,
          pauseAfterRound: Duration(seconds: 1),
          startPadding: 10.0,
          accelerationDuration: Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with space theme
          SizedBox.expand(
            child: Image.asset(
              'assets/images/homescreen.png',
              fit: BoxFit.cover,
            ),
          ),

          // Multi-layered background effects
          Opacity(opacity: 0.7, child: StarBackground(starCount: 150)),
          Opacity(
            opacity: 0.5,
            child: CosmicParticleBackground(
              particleCount: 20,
              colors: const [
                Colors.tealAccent,
                Colors.blueAccent,
                Colors.purpleAccent,
              ],
            ),
          ),
          Opacity(opacity: 0.8, child: ShootingStarField(starCount: 3)),

          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                bottom: 10.h,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: _buildMarqueeBanner(),
                ),
              );
            },
          ),

          // Animated planet
          Positioned(
            top: -60.h,
            right: -60.w,
            child: AnimatedBuilder(
              animation: _fadeInAnimation,
              builder: (context, child) {
                return Opacity(opacity: _fadeInAnimation.value, child: child);
              },
              child: Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.tealAccent.withOpacity(0.2),
                      blurRadius: 80,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Animated Header with greeting and avatar
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                left: 20.w,
                right: 10.w,
                top: 60.h - _slideAnimation.value,
                child: Opacity(
                  opacity: _fadeInAnimation.value,
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
                            } else if (profileController.profile.value !=
                                null) {
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
                                        color: Colors.tealAccent.withOpacity(
                                          0.5,
                                        ),
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

                      // Animated Avatar with pulsing border
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
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
                              padding: EdgeInsets.all(2.w), // Border width
                              child: CircleAvatar(
                                radius: 42.r,
                                backgroundColor: Colors.black.withOpacity(0.3),
                                backgroundImage: AssetImage(
                                  (profileController.profile.value != null &&
                                          profileController
                                                  .profile
                                                  .value!
                                                  .gender
                                                  .toLowerCase() ==
                                              'female')
                                      ? 'assets/images/female.png'
                                      : 'assets/images/male.png',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                top: 220.h + (1 - _fadeInAnimation.value) * 50,
                left: 20.w,
                right: 20.w,
                child: Opacity(
                  opacity: _fadeInAnimation.value,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Explore Planets Card
                          FuturisticDashboardCard(
                            title: "Discover Planets",
                            icon: Icons.public,
                            primaryColor: const Color(0xFF0A4DA2),
                            secondaryColor: const Color(0xFF0F2B61),
                            highlightColor: const Color(0xFF4FC3F7),
                            showShine: false,
                            onTap: () {
                              Get.to(
                                () => const ScrollPlanetsScreen(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                          ),

                          // Play Quiz Card
                          FuturisticDashboardCard(
                            title: "Play Quiz",
                            icon: Icons.quiz,
                            primaryColor: const Color(0xFF6A1B9A),
                            secondaryColor: const Color(0xFF4A148C),
                            highlightColor: const Color(0xFFAB47BC),
                            showShine: false,
                            onTap: () {
                              Get.to(
                                () => const QuizTypeScreen(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                          ),
                        ],
                      ),
                      5.h.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // View Animation Card
                          FuturisticDashboardCard(
                            title: "View Animation",
                            icon: Icons.play_circle_outline,
                            primaryColor: const Color(0xFF00695C),
                            secondaryColor: const Color(0xFF004D40),
                            highlightColor: const Color(0xFF1DE9B6),
                            showShine: false,
                            onTap: () {
                              Get.to(
                                () => const AnimationsMenuScreen(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                          ),

                          // Compare Planets Card
                          FuturisticDashboardCard(
                            title: "Compare Planets",
                            icon: Icons.compare_arrows,
                            primaryColor: const Color(0xFF880E4F),
                            secondaryColor: const Color(0xFF560027),
                            highlightColor: const Color(0xFFFF80AB),
                            showShine: false,
                            onTap: () {
                              Get.to(
                                () => const ComparePlanetsScreen(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                          ),
                        ],
                      ),
                      5.h.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FuturisticDashboardCard(
                            title: "Quiz Results",
                            icon: Icons.star_rate,
                            primaryColor: const Color(0xFFF57F17),
                            secondaryColor: const Color(0xFFC43E00),
                            highlightColor: const Color(0xFFFFD740),
                            showShine: false,
                            onTap: () {
                              Get.to(
                                () => QuizResultsListScreen(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                          ),

                          // Discover Galaxies Card
                          FuturisticDashboardCard(
                            title: "Discover Galaxies",
                            icon: Icons.auto_awesome,
                            primaryColor: const Color(0xFF006064),
                            secondaryColor: const Color(0xFF002930),
                            highlightColor: const Color(0xFF00E5FF),
                            showShine: false,
                            onTap: () {
                              Get.to(
                                () => GalaxiesListScreen(token: widget.token),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                          ),
                        ],
                      ),
                      5.h.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FuturisticDashboardCard(
                            title: "Discover Satellite",
                            icon: Icons.satellite_alt,
                            primaryColor: const Color(0xFFD32F2F), // Vivid red
                            secondaryColor: const Color(
                              0xFF121212,
                            ), // Deep black
                            highlightColor: const Color(
                              0xFFFF5252,
                            ), // Glowing red accent

                            showShine: false,
                            onTap: () {
                              Get.to(() => const SatelliteScreen());
                            },
                          ),

                          // Discover Stars Card
                          FuturisticDashboardCard(
                            title: "Discover Stars",
                            icon: Icons.auto_awesome,
                            primaryColor: const Color(0xFFC79100),
                            secondaryColor: const Color(0xFF7F4F00),
                            highlightColor: const Color(0xFFFFEA00),
                            showShine: false,
                            onTap: () {
                              Get.to(
                                () => StarsListScreen(token: widget.token),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
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
