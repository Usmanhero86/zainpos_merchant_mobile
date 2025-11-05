// import 'package:flutter/material.dart';
// import 'base_api_service.dart';
// import '../models/response_model/terminal_response.dart';
// import '../models/response_model/wallet_balance_response.dart';
//
// class TerminalService extends BaseApiService {
//   Future<TerminalResponse> fetchTerminals() async {
//     final response = await get('terminals');
//     return TerminalResponse.fromJson(response);
//   }
//
//   Future<WalletBalanceResponse?> getTerminalWalletBalance(String accountNumber) async {
//     try {
//       final response = await get('merchant/account_balance/$accountNumber');
//
//       if (response.containsKey('balance_amount')) {
//         return WalletBalanceResponse(
//           status: true,
//           message: 'Balance retrieved successfully',
//           data: WalletBalanceData(
//             accountName: response['account_name'] ?? '',
//             accountNumber: response['account_number'] ?? accountNumber,
//             balanceAmount: _parseBalance(response['balance_amount']),
//             bankName: response['bank_name'] ?? '',
//             currency: response['currency'] ?? 'NGN',
//           ),
//         );
//       } else {
//         return WalletBalanceResponse.fromJson(response);
//       }
//     } catch (e) {
//       debugPrint("Wallet Balance Error: $e");
//       return WalletBalanceResponse(
//         status: false,
//         message: 'Network error: $e',
//         data: null,
//       );
//     }
//   }
//
//   static double _parseBalance(dynamic balance) {
//     if (balance == null) return 0.0;
//     if (balance is int) return balance.toDouble();
//     if (balance is double) return balance;
//     if (balance is String) {
//       final cleaned = balance.replaceAll(RegExp(r'[^\d.]'), '');
//       return double.tryParse(cleaned) ?? 0.0;
//     }
//     return 0.0;
//   }
// }