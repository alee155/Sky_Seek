import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sky_seek/config/api_config.dart';

class ResultService {
  // Save quiz result to the server
  static Future<Map<String, dynamic>?> saveResult(
    String token, 
    String level, 
    int totalMarks, 
    int obtainMarks,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.saveResultEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'level': level,
          'totalMarks': totalMarks,
          'obtainMarks': obtainMarks,
        }),
      );

      debugPrint('Result API Response Status Code: ${response.statusCode}');
      debugPrint('Result API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        debugPrint('Failed to save result: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error saving result: $e');
      return null;
    }
  }
}
