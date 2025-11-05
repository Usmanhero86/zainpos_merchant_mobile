// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'base_api_service.dart';
// import '../models/response_model/bank_list_model.dart';
//
// class BankService extends BaseApiService {
//   Future<BankListResponse> fetchBankList() async {
//     final response = await get('banks');
//     return BankListResponse.fromJson(response);
//   }
//
//   Future<String?> resolveAccountEnquiry({
//     required String bankCode,
//     required String accountNumber,
//   }) async {
//     try {
//       final uri = Uri.parse('$baseUrl/name_enquiry').replace(
//         queryParameters: {
//           'bank_code': bankCode,
//           'account_number': accountNumber,
//         },
//       );
//
//       debugPrint("=== ACCOUNT ENQUIRY API CALL ===");
//       debugPrint("URL: $uri");
//
//       final response = await http.get(uri, headers: headers);
//       final jsonData = jsonDecode(response.body);
//
//       if (response.statusCode == 200) {
//         if (jsonData['code'] == '00' || jsonData['status'] == true || jsonData['success'] == true) {
//           final accountName = jsonData['data']?['accountName'] as String? ??
//               jsonData['data']?['account_name'] as String? ??
//               jsonData['accountName'] as String? ??
//               jsonData['account_name'] as String? ??
//               jsonData['data']?['name'] as String? ??
//               jsonData['name'] as String?;
//
//           if (accountName != null && accountName.isNotEmpty) {
//             debugPrint("✅ SUCCESS: Account resolved: $accountName");
//             return accountName.trim();
//           } else {
//             throw Exception('Account name not found in response data');
//           }
//         } else {
//           final errorMessage = jsonData['description'] ?? jsonData['message'] ?? 'Account resolution failed';
//           throw Exception(errorMessage);
//         }
//       } else {
//         throw Exception('Server error: ${response.statusCode}');
//       }
//     } on FormatException catch (e) {
//       debugPrint("JSON parsing error: $e");
//       throw Exception('Server returned invalid response');
//     }
//   }
// }