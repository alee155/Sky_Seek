import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sky_seek/controller/quiz_results_controller.dart';
import 'package:sky_seek/widgets/earth_loader.dart';
import 'package:sky_seek/widgets/star_background.dart';

class QuizResultsListScreen extends StatelessWidget {
  final QuizResultsController controller = Get.put(QuizResultsController());

  QuizResultsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00050E),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Quiz Results History",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'SpaceGrotesk',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/homescreen.png',
              fit: BoxFit.cover,
            ),
          ),

          // Animated stars overlay
          const Opacity(opacity: 0.5, child: StarBackground(starCount: 100)),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingIndicator();
              } else if (controller.hasError.value) {
                return _buildErrorWidget();
              } else if (controller.results.isEmpty) {
                return _buildEmptyState();
              } else {
                return _buildResultsList();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EarthLoader(size: 60),
        10.h.verticalSpace,
        Text(
          "Loading...",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Colors.redAccent.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.redAccent, size: 50.sp),
                SizedBox(height: 16.h),
                Text(
                  "Failed to load results",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchQuizResults(),
                  icon: const Icon(Icons.refresh),
                  label: Text("Try Again", style: TextStyle(fontSize: 16.sp)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    backgroundColor: Colors.tealAccent.withOpacity(0.7),
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: Colors.tealAccent.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.quiz_outlined, color: Colors.tealAccent, size: 60.sp),
            SizedBox(height: 16.h),
            Text(
              "No Quiz Results Yet",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Take a quiz to see your results here!",
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        // Performance summary card
        if (controller.results.isNotEmpty) _buildPerformanceSummary(),
        SizedBox(height: 20.h),
        // Results list
        Expanded(
          child: ListView.builder(
            itemCount: controller.results.length,
            itemBuilder: (context, index) {
              final result = controller.results[index];
              return _buildResultCard(result);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceSummary() {
    final averageScore = controller.averageScorePercentage;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: _getScoreColor(averageScore).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getScoreColor(averageScore).withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Performance Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Quizzes",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${controller.results.length}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Average Score",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${averageScore.toStringAsFixed(1)}%",
                    style: TextStyle(
                      color: _getScoreColor(averageScore),
                      fontSize: 24.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Performance indicator bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: averageScore / 100,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getScoreColor(averageScore),
              ),
              minHeight: 8.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(dynamic result) {
    // Calculate score percentage
    final percentage =
        result.totalMarks > 0
            ? (result.obtainMarks / result.totalMarks) * 100
            : 0;

    // Format date
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    final formattedDate = dateFormat.format(result.createdAt);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _getScoreColor(percentage).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and difficulty
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16.sp,
                    color: Colors.transparent,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.transparent,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(result.level).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: _getDifficultyColor(result.level).withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  result.level,
                  style: TextStyle(
                    color: _getDifficultyColor(result.level),
                    fontSize: 12.sp,
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Score",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${result.obtainMarks}",
                    style: TextStyle(
                      color: _getScoreColor(percentage),
                      fontSize: 24.sp,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "/${result.totalMarks}",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16.sp,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "(${percentage.toStringAsFixed(0)}%)",
                    style: TextStyle(
                      color: _getScoreColor(percentage),
                      fontSize: 14.sp,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Score progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getScoreColor(percentage),
              ),
              minHeight: 8.h,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.tealAccent;
    if (percentage >= 40) return Colors.amber;
    return Colors.redAccent;
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.amber;
      case 'hard':
        return Colors.redAccent;
      default:
        return Colors.tealAccent;
    }
  }
}
