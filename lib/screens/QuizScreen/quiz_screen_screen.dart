import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_seek/controller/quiz_controller.dart';
import 'package:sky_seek/screens/QuizScreen/quiz_result_screen.dart';
import 'package:sky_seek/widgets/earth_loader.dart';
import 'package:sky_seek/widgets/star_background.dart';

class QuizScreen extends StatefulWidget {
  final String level;

  const QuizScreen({super.key, required this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController quizController = Get.put(QuizController());
  final RxInt currentQuestionIndex = 0.obs;
  final RxString selectedOption = ''.obs;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    currentQuestionIndex.value = 0;
    selectedOption.value = '';
    quizController.resetQuiz();
    await quizController.fetchQuizByLevel(widget.level);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF00050E),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text(
              "Quiz: ${widget.level} Level",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Obx(
              () =>
                  quizController.isLoading.value
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.tealAccent,
                        ),
                      )
                      : const SizedBox(),
            ),
          ],
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Obx(() {
              if (quizController.isLoading.value) {
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
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              } else if (quizController.hasError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                      SizedBox(height: 16.h),
                      Text(
                        "Error loading quiz",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        quizController.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: _loadQuiz,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent.withOpacity(0.7),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text("Try Again"),
                      ),
                    ],
                  ),
                );
              } else if (quizController.quizzes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.quiz, color: Colors.amber, size: 48.sp),
                      SizedBox(height: 16.h),
                      Text(
                        "No quizzes available",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent.withOpacity(0.7),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text("Go Back"),
                      ),
                    ],
                  ),
                );
              }

              return Obx(() {
                final currentIndex = currentQuestionIndex.value;
                if (currentIndex >= quizController.quizzes.length) {
                  return Center(
                    child: Text(
                      "No question available at index $currentIndex",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  );
                }

                final currentQuiz = quizController.quizzes[currentIndex];

                final savedAnswer = quizController.userAnswers[currentQuiz.id];
                if (savedAnswer != null &&
                    selectedOption.value != savedAnswer) {
                  selectedOption.value = savedAnswer;
                } else if (savedAnswer == null) {
                  selectedOption.value = '';
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 150.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50.h,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF032666),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFF3571E2),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Question ${currentIndex + 1} of ${quizController.quizzes.length}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontFamily: 'SpaceGrotesk',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    Text(
                      "Question:",
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 20.sp,
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.tealAccent.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        currentQuiz.question,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 16.sp,
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    Text(
                      "Options:",
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 20.sp,
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    ...currentQuiz.options.map((option) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Obx(
                          () => _buildOptionItem(
                            option,
                            option == selectedOption.value,
                            () => selectedOption.value = option,
                          ),
                        ),
                      );
                    }),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentIndex > 0)
                          ElevatedButton.icon(
                            onPressed: () => currentQuestionIndex.value--,
                            icon: const Icon(Icons.arrow_back),
                            label: const Text("Previous"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey.withOpacity(0.7),
                              foregroundColor: Colors.white,
                            ),
                          )
                        else
                          const SizedBox(),

                        if (currentIndex < quizController.quizzes.length - 1)
                          Obx(() {
                            final currentQuiz =
                                quizController.quizzes[currentIndex];
                            final hasAnswered = quizController.userAnswers
                                .containsKey(currentQuiz.id);

                            return ElevatedButton.icon(
                              onPressed: () {
                                if (hasAnswered) {
                                  currentQuestionIndex.value++;
                                } else {
                                  Get.snackbar(
                                    "Please Answer",
                                    "Select an answer before proceeding to the next question",
                                    backgroundColor: Colors.amber.withOpacity(
                                      0.7,
                                    ),
                                    colorText: Colors.white,

                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.only(
                                      bottom: 20.h,
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    duration: const Duration(seconds: 2),
                                  );
                                }
                              },
                              icon: const Icon(Icons.arrow_forward),
                              label: Text(
                                hasAnswered ? "Next" : "Answer First",
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    hasAnswered
                                        ? Colors.tealAccent.withOpacity(0.7)
                                        : Colors.amber.withOpacity(0.7),
                                foregroundColor: Colors.black,
                              ),
                            );
                          })
                        else
                          Obx(() {
                            final allQuestionsAnswered =
                                _areAllQuestionsAnswered();
                            return ElevatedButton.icon(
                              onPressed:
                                  allQuestionsAnswered ? _finishQuiz : null,
                              icon: const Icon(Icons.check_circle),
                              label: Text(
                                allQuestionsAnswered
                                    ? "Finish Quiz"
                                    : "Answer All Questions",
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    allQuestionsAnswered
                                        ? Colors.green.withOpacity(0.7)
                                        : Colors.grey.withOpacity(0.7),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey
                                    .withOpacity(0.3),
                                disabledForegroundColor: Colors.white70,
                              ),
                            );
                          }),
                      ],
                    ),
                    SizedBox(height: 50.h),
                  ],
                );
              });
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(String option, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        _saveCurrentAnswer(option);
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Colors.tealAccent.withOpacity(0.2)
                  : Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? Colors.tealAccent : Colors.white30,
            width: isSelected ? 2 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.tealAccent.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                  : [],
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? Colors.tealAccent : Colors.white54,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCurrentAnswer(String option) {
    final currentQuiz = quizController.quizzes[currentQuestionIndex.value];
    quizController.saveAnswer(currentQuiz.id, option);
    selectedOption.value = option;
  }

  bool _areAllQuestionsAnswered() {
    final totalQuestions = quizController.quizzes.length;

    final answeredQuestions = quizController.userAnswers.length;

    return answeredQuestions >= totalQuestions;
  }

  void _finishQuiz() {
    quizController.calculateScore();
    Get.to(
      () => QuizResultScreen(quizController: quizController),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 500),
    );
  }
}
