import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/quiz_controller.dart';
import 'package:sky_seek/models/quiz_model.dart';
import 'package:sky_seek/screens/BottomNavBar/bottomnavbar_screen.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/widgets/star_background.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizController quizController;

  const QuizResultScreen({super.key, required this.quizController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00050E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00050E),
        title: Text(
          "Quiz Results",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontFamily: 'SpaceGrotesk',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Get.until((route) => route.isFirst);
          },
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/homescreen.png',
              fit: BoxFit.cover,
            ),
          ),

          const StarBackground(starCount: 100, opacity: 0.5),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 30.h),

                _buildResultsCard(),

                SizedBox(height: 30.h),

                if (quizController.incorrectAnswers.isNotEmpty)
                  _buildReviewButton(),

                const Spacer(),

                _buildBackToHomeButton(),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.tealAccent.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.format_list_numbered,
                color: Colors.tealAccent,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                "Level: ${quizController.selectedLevel.value}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Container(
            width: double.infinity,
            height: 120.h,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Score",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${quizController.obtainedMarks.value}",
                      style: TextStyle(
                        color: _getScoreColor(
                          quizController.obtainedMarks.value,
                          quizController.totalMarks.value,
                        ),
                        fontSize: 40.sp,
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "/${quizController.totalMarks.value}",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24.sp,
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          Text(
            _getPerformanceMessage(
              quizController.obtainedMarks.value,
              quizController.totalMarks.value,
            ),
            style: TextStyle(
              color: _getScoreColor(
                quizController.obtainedMarks.value,
                quizController.totalMarks.value,
              ),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Get.to(
          () => QuizReviewScreen(
            incorrectQuizzes: quizController.incorrectAnswers,
            userAnswers: quizController.userAnswers,
          ),
        );
      },
      icon: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: const Icon(Icons.assessment),
      ),
      label: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Text(
          "Review Incorrect Answers (${quizController.incorrectAnswers.length})",
          style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins'),
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        backgroundColor: Colors.amber.withOpacity(0.7),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildBackToHomeButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        Get.dialog(
          Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: Colors.tealAccent.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 40.w,
                    height: 40.h,
                    child: const CircularProgressIndicator(
                      color: Colors.tealAccent,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Saving your result...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );

        final success = await quizController.saveResult();

        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }
        if (Get.context != null) {
          Navigator.of(Get.context!).pop();
        }

        Get.snackbar(
          success ? "Success" : "Notice",
          success
              ? "Result saved successfully!"
              : "Continuing without saving result",
          backgroundColor:
              success
                  ? Colors.green.withOpacity(0.7)
                  : Colors.amber.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
          duration: const Duration(seconds: 2),
        );

        _navigateToHome();
      },
      icon: const Icon(Icons.home),
      label: Text(
        "Back to Home",
        style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins'),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 32.w),
        backgroundColor: Colors.tealAccent.withOpacity(0.7),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  void _navigateToHome() async {
    final token = await AuthService.getToken() ?? '';
    Get.offAll(
      () => BottomNavScreen(token: token),
      transition: Transition.fadeIn,
    );
  }

  Color _getScoreColor(int obtained, int total) {
    final percentage = obtained / total;
    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.6) return Colors.tealAccent;
    if (percentage >= 0.4) return Colors.amber;
    return Colors.redAccent;
  }

  String _getPerformanceMessage(int obtained, int total) {
    final percentage = obtained / total;
    if (percentage >= 0.8) return "Excellent! Great job!";
    if (percentage >= 0.6) return "Good work!";
    if (percentage >= 0.4) return "Nice try!";
    return "Keep practicing!";
  }
}

class QuizReviewScreen extends StatelessWidget {
  final List<QuizModel> incorrectQuizzes;
  final Map<String, String> userAnswers;

  const QuizReviewScreen({
    super.key,
    required this.incorrectQuizzes,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00050E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00050E),
        title: Text(
          "Review Answers",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/homescreen.png',
              fit: BoxFit.cover,
            ),
          ),

          const StarBackground(starCount: 100, opacity: 0.5),

          ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: incorrectQuizzes.length,
            itemBuilder: (context, index) {
              final quiz = incorrectQuizzes[index];
              final userAnswer = userAnswers[quiz.id] ?? "No answer";

              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Q${index + 1}: ${quiz.question}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    Row(
                      children: [
                        Icon(Icons.close, color: Colors.red, size: 18.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Your answer: ",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                TextSpan(
                                  text: userAnswer,
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.green, size: 18.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Correct answer: ",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                TextSpan(
                                  text: quiz.correctAnswer,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
