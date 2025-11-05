// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class BaseApiService {
//   final String baseUrl = 'https://merchant.sandbox.zainpos.ng/api/v1';
//   final String secretKey = "df32anxmxxxainwodwwsmanttss";
//   String? authToken;
//
//   Map<String, String> get headers {
//     return {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       if (authToken != null) 'Authorization': 'Bearer $authToken',
//     };
//   }
//
//   Map<String, String> get headersWithoutAuth {
//     return {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//   }
//
//   Future<Map<String, dynamic>> handleResponse(http.Response response) async {
//     debugPrint("API Response - Status: ${response.statusCode}");
//     debugPrint("API Response - Body: ${response.body}");
//
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('API Error: ${response.statusCode} - ${response.reasonPhrase}');
//     }
//   }
//
//   Future<Map<String, dynamic>> get(String endpoint) async {
//     final url = Uri.parse('$baseUrl/$endpoint');
//     final response = await http.get(url, headers: headers);
//     return handleResponse(response);
//   }
//
//   Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
//     final url = Uri.parse('$baseUrl/$endpoint');
//     final response = await http.post(
//       url,
//       headers: headers,
//       body: jsonEncode(body),
//     );
//     return handleResponse(response);
//   }
//
//   Future<Map<String, dynamic>> postWithoutAuth(String endpoint, Map<String, dynamic> body) async {
//     final url = Uri.parse('$baseUrl/$endpoint');
//     final response = await http.post(
//       url,
//       headers: headersWithoutAuth,
//       body: jsonEncode(body),
//     );
//     return handleResponse(response);
//   }
// }