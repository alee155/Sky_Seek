import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sky_seek/models/quiz_results_model.dart';
import 'package:sky_seek/services/auth_service.dart';
import 'package:sky_seek/config/api_config.dart';

class QuizResultsController extends GetxController {
  final RxList<QuizResultModel> results = <QuizResultModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuizResults();
  }

  Future<void> fetchQuizResults() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Get the auth token
      final token = await AuthService.getToken();
      
      if (token == null || token.isEmpty) {
        hasError.value = true;
        errorMessage.value = 'Authentication token is missing';
        return;
      }

      // Make the API request
      final response = await http.get(
        Uri.parse(ApiConfig.quizResultsEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response
        final List<dynamic> data = json.decode(response.body);
        results.value = data.map((item) => QuizResultModel.fromJson(item)).toList();
      } else {
        debugPrint('Failed to load quiz results. Status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        hasError.value = true;
        errorMessage.value = 'Failed to load quiz results (${response.statusCode})';
      }
    } catch (e) {
      debugPrint('Error fetching quiz results: $e');
      hasError.value = true;
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate the average score percentage
  double get averageScorePercentage {
    if (results.isEmpty) return 0;
    
    int totalObtained = 0;
    int totalPossible = 0;
    
    for (var result in results) {
      totalObtained += result.obtainMarks;
      totalPossible += result.totalMarks;
    }
    
    return totalPossible > 0 ? (totalObtained / totalPossible) * 100 : 0;
  }
  
  // Get formatted date string
  String getFormattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
