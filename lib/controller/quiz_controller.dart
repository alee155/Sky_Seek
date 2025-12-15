import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_seek/models/quiz_model.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/services/quiz_service.dart';
import 'package:sky_seek/services/result_service.dart';
import 'package:sky_seek/utils/snackbar_helper.dart';

class QuizController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var quizData = Rxn<List<dynamic>>();
  var quizzes = <QuizModel>[].obs;
  var selectedLevel = ''.obs;

  // Track user answers and scores
  var userAnswers = <String, String>{}.obs; // questionId -> selectedAnswer
  var isQuizCompleted = false.obs;
  var totalMarks = 0.obs;
  var obtainedMarks = 0.obs;
  var incorrectAnswers = <QuizModel>[].obs;

  // Fetch quiz based on difficulty level
  Future<void> fetchQuizByLevel(String level) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    selectedLevel.value = level;

    try {
      // Get token from auth service
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) {
        hasError.value = true;
        errorMessage.value = 'Authentication token not found';
        debugPrint('Error: Authentication token not found');
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showError(context, 'Authentication token not found');
        }
        return;
      }

      // Fetch quiz data
      final data = await QuizService.getQuiz(token, level);

      if (data != null) {
        quizData.value = data;
        debugPrint('Quiz data fetched successfully');

        // Process the response to extract quizzes
        try {
          // Direct parsing of JSON array to quiz models
          final List<QuizModel> quizList =
              data.map((item) => QuizModel.fromJson(item)).toList();
          quizzes.assignAll(quizList);
          debugPrint('Loaded ${quizzes.length} quizzes');
        } catch (e) {
          hasError.value = true;
          errorMessage.value = 'Error parsing quiz data: $e';
          debugPrint('Error parsing quiz data: $e');
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to fetch quiz data';
        debugPrint('Failed to fetch quiz data');
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showError(context, 'Failed to fetch quiz data');
        }
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error: $e';
      debugPrint('Error in fetchQuizByLevel: $e');
      final context = Get.context;
      if (context != null) {
        SnackbarHelper.showError(context, 'Error loading quiz');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Save user's answer for a specific question
  void saveAnswer(String questionId, String selectedAnswer) {
    userAnswers[questionId] = selectedAnswer;
  }

  // Calculate final score when quiz is completed
  void calculateScore() {
    if (quizzes.isEmpty) return;

    totalMarks.value = quizzes.length;
    int correct = 0;
    incorrectAnswers.clear();

    for (var quiz in quizzes) {
      final userAnswer = userAnswers[quiz.id];
      if (userAnswer == quiz.correctAnswer) {
        correct++;
      } else if (userAnswer != null) {
        // Add to incorrect answers list for review
        incorrectAnswers.add(quiz);
      }
    }

    obtainedMarks.value = correct;
    isQuizCompleted.value = true;

    debugPrint('Quiz completed: $obtainedMarks/${totalMarks.value}');
    debugPrint('Incorrect answers: ${incorrectAnswers.length}');
  }

  // Reset quiz state for a new attempt
  void resetQuiz() {
    userAnswers.clear();
    isQuizCompleted.value = false;
    totalMarks.value = 0;
    obtainedMarks.value = 0;
    incorrectAnswers.clear();
  }

  // Save quiz result to the server
  Future<bool> saveResult() async {
    try {
      final token = await AuthService.getToken();

      if (token == null || token.isEmpty) {
        debugPrint('Error: Authentication token not found');
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showError(context, 'Authentication token not found');
        }
        return false;
      }

      final result = await ResultService.saveResult(
        token,
        selectedLevel.value,
        totalMarks.value,
        obtainedMarks.value,
      );

      if (result != null) {
        debugPrint('Result saved successfully');
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showQuizResult(
            context,
            obtainedMarks.value,
            totalMarks.value,
          );
        }
        return true;
      } else {
        debugPrint('Failed to save result');
        final context = Get.context;
        if (context != null) {
          SnackbarHelper.showError(context, 'Failed to save quiz result');
        }
        return false;
      }
    } catch (e) {
      debugPrint('Error saving result: $e');
      final context = Get.context;
      if (context != null) {
        SnackbarHelper.showError(context, 'Error saving quiz result');
      }
      return false;
    }
  }
}
