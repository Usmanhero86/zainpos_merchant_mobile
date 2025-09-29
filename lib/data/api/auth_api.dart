import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'api_endpoints.dart';

class AuthApi {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> signup({required String email,required String password,}) async {
    final res = await _client.post(
      ApiEndpoints.signup,
      body: {'email': email, 'password': password},
    );
    _check(res);
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> login({required String email, required String password,}) async {
    final res = await _client.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );
    _check(res);
    final data = jsonDecode(res.body);
    if (data['token'] != null) {
      await _client.setToken(data['token']);
    }
    return data;
  }

  void _check(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Auth API error: ${res.statusCode} ${res.body}');
    }
  }
}
