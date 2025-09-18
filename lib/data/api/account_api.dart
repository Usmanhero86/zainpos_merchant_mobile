import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'api_endpoints.dart';

class AccountApi {
  final _client = ApiClient();

  Future<Map<String, dynamic>> fetchAccount() async {
    final res = await _client.get(ApiEndpoints.account);
    _check(res);
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateAccount(Map<String, dynamic> body) async {
    final res = await _client.put(ApiEndpoints.account, body: body);
    _check(res);
    return jsonDecode(res.body);
  }

  void _check(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Account API error: ${res.statusCode} ${res.body}');
    }
  }
}
