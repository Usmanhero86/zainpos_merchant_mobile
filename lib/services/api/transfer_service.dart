// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'base_api_service.dart';
// import '../models/response_model/transfer_response_model.dart';
//
// class TransferService extends BaseApiService {
//   Future<TransferResponse> initiateFundTransfer({
//     required String destinationAccountNumber,
//     required String destinationAccountName,
//     required String destinationBankCode,
//     required String destinationBankName,
//     required String amount,
//     required String sourceAccountNumber,
//     required String zainboxCode,
//     required String narration,
//     required String terminalId,
//     required String pin,
//   }) async {
//     debugPrint("=== FUND TRANSFER API CALL ===");
//
//     final body = {
//       "destination_account_number": destinationAccountNumber,
//       "destination_account_name": destinationAccountName,
//       "destination_bank_code": destinationBankCode,
//       "destination_bank_name": destinationBankName,
//       "amount": amount,
//       "source_account_number": sourceAccountNumber,
//       "zainbox_code": zainboxCode,
//       "narration": narration,
//       "terminal_id": terminalId,
//       "pin": pin,
//     };
//
//     debugPrint("Request Body: ${jsonEncode(body)}");
//
//     try {
//       final response = await post('merchant/transfer/v2', body);
//       return TransferResponse.fromJson(response);
//     } catch (e) {
//       debugPrint("Fund Transfer Error: $e");
//       return TransferResponse(
//         isSuccess: false,
//         Success: false,
//         message: 'Network error: ${e.toString().replaceAll('Exception: ', '')}',
//         error: true,
//         errorType: 'NetworkError',
//       );
//     }
//   }
// }