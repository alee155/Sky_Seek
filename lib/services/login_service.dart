import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sky_seek/models/login_model.dart';
import 'package:sky_seek/config/api_config.dart';

class LoginService {
  static Future<http.Response> login(LoginModel model) async {
    final url = Uri.parse(ApiConfig.signinEndpoint);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    return response;
  }
}
