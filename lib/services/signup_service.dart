import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sky_seek/models/signup_model.dart';
import 'package:sky_seek/config/api_config.dart';

class SignupService {
  static Future<http.Response> signup(SignupModel model) async {
    final url = Uri.parse(ApiConfig.signupEndpoint);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    return response;
  }
}
