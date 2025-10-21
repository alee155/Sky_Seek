import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sky_seek/config/api_config.dart';

class QuizService {
  // Fetch quiz based on difficulty level
  static Future<List<dynamic>?> getQuiz(String token, String level) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.getQuizEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'level': level,
        }),
      );

      debugPrint('Quiz API Response Status Code: ${response.statusCode}');
      debugPrint('Quiz API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Check if the response is a JSON array
        if (data is List) {
          return data;
        } else {
          debugPrint('Unexpected response format. Expected a list, got: ${data.runtimeType}');
          return null;
        }
      } else {
        debugPrint('Failed to load quiz: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching quiz: $e');
      return null;
    }
  }
}
