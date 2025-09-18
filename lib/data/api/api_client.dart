import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final _storage = const FlutterSecureStorage();

  static const String baseUrl = 'https://merchant.sandbox.zainpos.ng/api/v1';
  String? _token;

  Future<void> setToken(String token) async {
    _token = token;
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> loadToken() async {
    _token ??= await _storage.read(key: 'auth_token');
  }

  Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
  }

  Future<http.Response> get(String path) async {
    await loadToken();
    final uri = Uri.parse('$baseUrl$path');
    return http.get(uri, headers: _headers());
  }

  Future<http.Response> post(String path, {Map<String, dynamic>? body}) async {
    await loadToken();
    final uri = Uri.parse('$baseUrl$path');
    return http.post(uri, headers: _headers(), body: jsonEncode(body));
  }

  Future<http.Response> put(String path, {Map<String, dynamic>? body}) async {
    await loadToken();
    final uri = Uri.parse('$baseUrl$path');
    return http.put(uri, headers: _headers(), body: jsonEncode(body));
  }

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }
}
