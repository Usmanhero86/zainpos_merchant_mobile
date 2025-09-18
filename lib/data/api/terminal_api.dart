import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'api_endpoints.dart';

class TerminalApi {
  final _client = ApiClient();

  Future<List<dynamic>> fetchTerminals() async {
    final res = await _client.get(ApiEndpoints.terminals);
    _check(res);
    return jsonDecode(res.body);
  }

  void _check(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Terminal API error: ${res.statusCode} ${res.body}');
    }
  }
}
