import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'api_endpoints.dart';

class TransactionApi {
  final _client = ApiClient();

  Future<List<dynamic>> listTransactions({int page = 1}) async {
    final res = await _client.get('${ApiEndpoints.transactions}?page=$page');
    _check(res);
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> createTransaction(Map<String, dynamic> body) async {
    final res = await _client.post(ApiEndpoints.transactions, body: body);
    _check(res);
    return jsonDecode(res.body);
  }

  void _check(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Transaction API error: ${res.statusCode} ${res.body}');
    }
  }
}
