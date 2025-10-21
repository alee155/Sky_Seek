import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sky_seek/widgets/star_background.dart';
import 'package:get/get.dart';
import 'package:sky_seek/screens/QuizScreen/quiz_screen_screen.dart';

class QuizTypeScreen extends StatefulWidget {
  const QuizTypeScreen({super.key});

  @override
  State<QuizTypeScreen> createState() => _QuizTypeScreenState();
}

class _QuizTypeScreenState extends State<QuizTypeScreen>
    with TickerProviderStateMixin {
  // Track whether each difficulty toast has been shown using GetX reactive variables
  final easyToastShown = false.obs;
  final mediumToastShown = false.obs;
  final hardToastShown = false.obs;
  late AnimationController _animationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  final List<String> _titleWords = ["Select", "Your", "Challenge"];
  final titleWord0Visible = false.obs;
  final titleWord1Visible = false.obs;
  final titleWord2Visible = false.obs;

  @override
  void initState() {
    super.initState();

    // Initialize main animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Initialize pulse animation for ambient effects
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

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

    // Start animations after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();

      // Animate title words one by one
      Future.delayed(const Duration(milliseconds: 300), () {
        titleWord0Visible.value = true;
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        titleWord1Visible.value = true;
      });

      Future.delayed(const Duration(milliseconds: 900), () {
        titleWord2Visible.value = true;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  Widget _buildDifficultyButton({
    required String difficulty,
    required Color startColor,
    required Color endColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              curve: Curves.elasticOut,
              duration: const Duration(milliseconds: 1000),
              builder: (context, scale, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeInAnimation.value,
                    child: Transform.scale(scale: scale, child: child),
                  ),
                );
              },
              child: MouseRegion(
                onEnter: (_) => setState(() => isHovered = true),
                onExit: (_) => setState(() => isHovered = false),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 1.0, end: isHovered ? 1.05 : 1.0),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  builder: (context, hoverScale, child) {
                    return Transform.scale(scale: hoverScale, child: child);
                  },
                  child: GestureDetector(
                    onTap: () {
                      // Add a tap animation
                      setState(() => isHovered = false);
                      Future.delayed(const Duration(milliseconds: 50), () {
                        setState(() => isHovered = true);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          onTap();
                        });
                      });
                    },
                    child: Container(
                      width: 280.w,
                      height: 75.h,
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [startColor, endColor],
                        ),
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isHovered
                                    ? endColor.withOpacity(0.7)
                                    : endColor.withOpacity(0.4),
                            blurRadius: isHovered ? 15 : 10,
                            spreadRadius: isHovered ? 2 : 1,
                          ),
                        ],
                        border: Border.all(
                          color:
                              isHovered
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.white.withOpacity(0.2),
                          width: isHovered ? 2.0 : 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(
                              begin: 0.0,
                              end: isHovered ? 1.0 : 0.0,
                            ),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, rotation, child) {
                              return Transform.rotate(
                                angle: rotation * 0.1,
                                child: Icon(
                                  icon,
                                  color:
                                      isHovered
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.9),
                                  size: isHovered ? 32.sp : 28.sp,
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            difficulty,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isHovered ? 26.sp : 24.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SpaceGrotesk',
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  blurRadius: isHovered ? 10 : 5,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00050E),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/homescreen.png',
              fit: BoxFit.cover,
            ),
          ),

          // Animated stars overlay
          const Opacity(opacity: 0.8, child: StarBackground(starCount: 150)),

          // Space themed ambient lighting with pulse animation
          AnimatedBuilder(
            animation: _pulseAnimationController,
            builder: (context, child) {
              return Stack(
                children: [
                  // Top right teal accent light
                  Positioned(
                    top: -50,
                    right: -100,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.tealAccent.withOpacity(
                              0.2 + (_pulseAnimation.value * 0.1),
                            ),
                            blurRadius: 100 + (_pulseAnimation.value * 20),
                            spreadRadius: 50 + (_pulseAnimation.value * 10),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom left blue accent light
                  Positioned(
                    bottom: -80,
                    left: -60,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(
                              0.1 + (_pulseAnimation.value * 0.1),
                            ),
                            blurRadius: 80 + (_pulseAnimation.value * 20),
                            spreadRadius: 40 + (_pulseAnimation.value * 10),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Center purple accent light (subtle)
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2 - 100,
                    right: -120,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purpleAccent.withOpacity(
                              0.05 + (_pulseAnimation.value * 0.05),
                            ),
                            blurRadius: 60 + (_pulseAnimation.value * 20),
                            spreadRadius: 30 + (_pulseAnimation.value * 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Header and back button
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                top: 60.h - _slideAnimation.value,
                left: 20.w,
                right: 20.w,
                child: Opacity(
                  opacity: _fadeInAnimation.value,
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimationController,
                        builder: (context, _) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.tealAccent.withOpacity(
                                    0.2 + (_pulseAnimation.value * 0.3),
                                  ),
                                  blurRadius: 10 + (_pulseAnimation.value * 5),
                                  spreadRadius: 2 + (_pulseAnimation.value * 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Animated title words
                          Row(
                            children: [
                              // First word
                              Obx(
                                () => AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: titleWord0Visible.value ? 1.0 : 0.0,
                                  curve: Curves.easeInOut,
                                  child: AnimatedBuilder(
                                    animation: _pulseAnimationController,
                                    builder: (context, _) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: Text(
                                          _titleWords[0],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.sp,
                                            fontFamily: 'SpaceGrotesk',
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: Colors.white.withOpacity(
                                                  0.5,
                                                ),
                                                blurRadius: 10.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Second word
                              Obx(
                                () => AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: titleWord1Visible.value ? 1.0 : 0.0,
                                  curve: Curves.easeInOut,
                                  child: AnimatedBuilder(
                                    animation: _pulseAnimationController,
                                    builder: (context, _) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: Text(
                                          _titleWords[1],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'SpaceGrotesk',
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: Colors.white.withOpacity(
                                                  0.5,
                                                ),
                                                blurRadius: 10.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Third word (with pulse effect)
                              Obx(
                                () => AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: titleWord2Visible.value ? 1.0 : 0.0,
                                  curve: Curves.easeInOut,
                                  child: AnimatedBuilder(
                                    animation: _pulseAnimationController,
                                    builder: (context, _) {
                                      final shadowIntensity =
                                          0.5 + (_pulseAnimation.value * 0.3);
                                      final shadowBlur =
                                          10.0 + (_pulseAnimation.value * 5);

                                      return Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: Text(
                                          _titleWords[2],
                                          style: TextStyle(
                                            color: Colors.tealAccent,
                                            fontFamily: 'SpaceGrotesk',
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: Colors.tealAccent
                                                    .withOpacity(
                                                      shadowIntensity,
                                                    ),
                                                blurRadius: shadowBlur,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Obx(
                            () => AnimatedOpacity(
                              duration: const Duration(milliseconds: 1000),
                              opacity: titleWord2Visible.value ? 1.0 : 0.0,
                              child: Text(
                                "Choose your quiz difficulty level",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Difficulty buttons container
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDifficultyButton(
                    difficulty: "Easy",
                    startColor: const Color(0xFF2A5F3C),
                    endColor: const Color(0xFF3A7F5C),
                    icon: Icons.sentiment_satisfied_alt,
                    onTap: () {
                      if (!easyToastShown.value) {
                        Get.snackbar(
                          "Easy Mode",
                          "Loading easy quiz questions...",
                          backgroundColor: Colors.green.withOpacity(0.7),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.only(
                            bottom: 20.h,
                            left: 20.w,
                            right: 20.w,
                          ),
                        );
                        easyToastShown.value = true;
                      }

                      // Navigate to quiz screen with easy mode
                      Get.to(
                        () => QuizScreen(level: "Easy"),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                  ),
                  _buildDifficultyButton(
                    difficulty: "Medium",
                    startColor: const Color(0xFF3A556B),
                    endColor: const Color(0xFF4A658B),
                    icon: Icons.sentiment_neutral,
                    onTap: () {
                      if (!mediumToastShown.value) {
                        Get.snackbar(
                          "Medium Mode",
                          "Loading medium quiz questions...",
                          backgroundColor: Colors.blue.withOpacity(0.7),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.only(
                            bottom: 20.h,
                            left: 20.w,
                            right: 20.w,
                          ),
                        );
                        mediumToastShown.value = true;
                      }

                      // Navigate to quiz screen with medium mode
                      Get.to(
                        () => QuizScreen(level: "Medium"),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                  ),
                  _buildDifficultyButton(
                    difficulty: "Hard",
                    startColor: const Color(0xFF6B2D2D),
                    endColor: const Color(0xFF8B3D3D),
                    icon: Icons.sentiment_very_dissatisfied,
                    onTap: () {
                      if (!hardToastShown.value) {
                        Get.snackbar(
                          "Hard Mode",
                          "Loading hard quiz questions...",
                          backgroundColor: Colors.red.withOpacity(0.7),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.only(
                            bottom: 20.h,
                            left: 20.w,
                            right: 20.w,
                          ),
                        );
                        hardToastShown.value = true;
                      }

                      // Navigate to quiz screen with hard mode
                      Get.to(
                        () => QuizScreen(level: "Hard"),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
