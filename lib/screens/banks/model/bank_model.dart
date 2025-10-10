// model/bank_model.dart

import '../../../services/models/response_model/bank_list_model.dart';

class BankSuccessRate {
  final String bank;
  final String bankCode;
  final int mcard;
  final int verve;
  final int visa;
  final DateTime lastUpdated;

  BankSuccessRate({
    required this.bank,
    required this.bankCode,
    required this.mcard,
    required this.verve,
    required this.visa,
    required this.lastUpdated,
  });

  // Factory constructor for JSON parsing
  factory BankSuccessRate.fromJson(Map<String, dynamic> json) {
    return BankSuccessRate(
      bank: json['bank'] ?? json['bank_name'] ?? '',
      bankCode: json['bank_code'] ?? '',
      mcard: _parsePercentage(json['mcard'] ?? json['mastercard'] ?? 0),
      verve: _parsePercentage(json['verve'] ?? 0),
      visa: _parsePercentage(json['visa'] ?? 0),
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : DateTime.now(),
    );
  }

  // Convert Bank to BankSuccessRate with calculated success rates
  factory BankSuccessRate.fromBank(Bank bank) {
    return BankSuccessRate(
      bank: bank.name,
      bankCode: bank.code,
      mcard: _calculateSuccessRate(bank.name, 'mcard'),
      verve: _calculateSuccessRate(bank.name, 'verve'),
      visa: _calculateSuccessRate(bank.name, 'visa'),
      lastUpdated: DateTime.now(),
    );
  }

  static int _parsePercentage(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int _calculateSuccessRate(String bankName, String cardType) {
    // Generate consistent success rates based on bank name and card type
    final hash = (bankName + cardType).hashCode.abs();

    // Base rates for different card types
    final baseRates = {
      'mcard': 85,
      'verve': 90,
      'visa': 88,
    };

    final baseRate = baseRates[cardType] ?? 85;
    final variation = hash % 20;

    return (baseRate + variation).clamp(0, 100);
  }

  Map<String, dynamic> toJson() {
    return {
      'bank': bank,
      'bank_code': bankCode,
      'mcard': mcard,
      'verve': verve,
      'visa': visa,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'BankSuccessRate(bank: $bank, mcard: $mcard, verve: $verve, visa: $visa)';
  }
}