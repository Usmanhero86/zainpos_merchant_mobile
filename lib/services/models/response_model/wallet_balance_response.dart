import 'dart:convert';
import 'package:flutter/material.dart';

class WalletBalanceResponse {
  final bool status;
  final String message;
  final WalletBalanceData data;

  WalletBalanceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
    // The API response doesn't have a nested 'data' field
    // The balance information is at the root level
    return WalletBalanceResponse(
      status: json['status'] ?? true, // Default to true since we got a response
      message: json['message'] ?? 'Balance retrieved successfully',
      data: WalletBalanceData.fromJson(json), // Pass the entire JSON, not json['data']
    );
  }

  factory WalletBalanceResponse.fromRawJson(String str) =>
      WalletBalanceResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

class WalletBalanceData {
  final String accountName;
  final String accountNumber;
  final double balanceAmount;
  final String bankName;
  final String currency;

  WalletBalanceData({
    required this.accountName,
    required this.accountNumber,
    required this.balanceAmount,
    required this.bankName,
    required this.currency,
  });

  factory WalletBalanceData.fromJson(Map<String, dynamic> json) {
    return WalletBalanceData(
      accountName: json['account_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      balanceAmount: _parseBalance(json['balance_amount']),
      bankName: json['bank_name'] ?? '',
      currency: json['currency'] ?? 'NGN',
    );
  }

  // Make this method static so it can be called from outside
  static double _parseBalance(dynamic balance) {
    if (balance == null) return 0.0;

    debugPrint("Parsing balance: $balance (type: ${balance.runtimeType})");

    if (balance is int) {
      return balance.toDouble();
    } else if (balance is double) {
      return balance;
    } else if (balance is String) {
      final cleaned = balance.replaceAll(RegExp(r'[^\d.]'), '');
      debugPrint("Cleaned balance string: $cleaned");

      final parsed = double.tryParse(cleaned) ?? 0.0;
      debugPrint("Parsed balance: $parsed");
      return parsed;
    }

    return 0.0;
  }

  Map<String, dynamic> toJson() => {
    'account_name': accountName,
    'account_number': accountNumber,
    'balance_amount': balanceAmount,
    'bank_name': bankName,
    'currency': currency,
  };
}