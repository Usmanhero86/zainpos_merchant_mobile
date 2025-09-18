import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://merchant.sandbox.zainpos.ng/api/v1";

  Future<bool> verifyPin(String pin) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pin': pin}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}