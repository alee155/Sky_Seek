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

class _QuizTypeScreenState extends State<QuizTypeScreen> {
  final List<String> _titleWords = ["Select", "Your", "Challenge"];

  Widget _buildDifficultyButton({
    required String difficulty,
    required Color startColor,
    required Color endColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
              color: endColor.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28.sp),
            SizedBox(width: 12.w),
            Text(
              difficulty,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'SpaceGrotesk',
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00050E),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/homescreen.png',
              fit: BoxFit.cover,
            ),
          ),

          const StarBackground(starCount: 150, opacity: 0.8),

          Positioned(
            top: 60.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:
                          _titleWords
                              .map(
                                (word) => Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: Text(
                                    word,
                                    style: TextStyle(
                                      color:
                                          word == _titleWords[2]
                                              ? Colors.tealAccent
                                              : Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SpaceGrotesk',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Choose your quiz difficulty level",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

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
                      Get.to(
                        () => QuizScreen(level: "Easy"),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                  _buildDifficultyButton(
                    difficulty: "Medium",
                    startColor: const Color(0xFF3A556B),
                    endColor: const Color(0xFF4A658B),
                    icon: Icons.sentiment_neutral,
                    onTap: () {
                      Get.to(
                        () => QuizScreen(level: "Medium"),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                  _buildDifficultyButton(
                    difficulty: "Hard",
                    startColor: const Color(0xFF6B2D2D),
                    endColor: const Color(0xFF8B3D3D),
                    icon: Icons.sentiment_very_dissatisfied,
                    onTap: () {
                      Get.to(
                        () => QuizScreen(level: "Hard"),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 300),
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
