import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sky_seek/config/api_config.dart';

class AccountService {
  /// Delete user account through the API
  static Future<Map<String, dynamic>> deleteAccount(String token) async {
    try {
      final url = Uri.parse(ApiConfig.deleteAccountEndpoint);
      debugPrint('==========================================');
      debugPrint('DELETE ACCOUNT API REQUEST:');
      debugPrint('URL: ${url.toString()}');
      debugPrint('HEADERS: Authorization: Bearer ${token.substring(0, min(10, token.length))}... (truncated)');
      debugPrint('==========================================');

      final response = await http
          .delete(
            url,
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          )
          .timeout(const Duration(seconds: 15));

      // Print detailed response to terminal
      debugPrint('==========================================');
      debugPrint('DELETE ACCOUNT API RESPONSE:');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');
      debugPrint('==========================================');
      
      // Process response
      Map<String, dynamic> rawResponse = {};
      if (response.body.isNotEmpty) {
        try {
          rawResponse = jsonDecode(response.body);
        } catch (e) {
          rawResponse = {'message': 'No readable response or parsing error'};
        }
      } else {
        // Empty response body is common for successful DELETE requests
        rawResponse = {'message': 'Account deleted successfully'};
      }
      
      return {
        'success': response.statusCode == 200 || response.statusCode == 204,
        'statusCode': response.statusCode,
        'rawResponse': rawResponse,
      };
    } catch (e) {
      debugPrint('Error in delete account request: $e');
      return {
        'success': false,
        'statusCode': -1,
        'rawResponse': {'error': e.toString()},
      };
    }
  }
  
  // Helper function to get min value
  static int min(int a, int b) {
    return a < b ? a : b;
  }
}
