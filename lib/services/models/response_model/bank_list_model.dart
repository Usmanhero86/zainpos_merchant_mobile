import 'package:flutter/material.dart';

class BankListResponse {
  final String code;
  final List<Bank> data;

  BankListResponse({
    required this.code,
    required this.data,
  });

  factory BankListResponse.fromJson(Map<String, dynamic> json) {
    return BankListResponse(
      code: json['code'] ?? '',
      data: (json['data'] as List)
          .map((e) => Bank.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };

  // Helper method to check if response is successful
  bool get isSuccess => code == '00';

  // Helper method to get banks sorted by name
  List<Bank> get banksSortedByName {
    final sortedList = List<Bank>.from(data);
    sortedList.sort((a, b) => a.name.compareTo(b.name));
    return sortedList;
  }

  // Helper method to search banks by name or code
  List<Bank> searchBanks(String query) {
    if (query.isEmpty) return data;

    final lowercaseQuery = query.toLowerCase();
    return data.where((bank) =>
    bank.name.toLowerCase().contains(lowercaseQuery) ||
        bank.code.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }

  // Helper method to get bank by code
  Bank? getBankByCode(String code) {
    try {
      return data.firstWhere((bank) => bank.code == code);
    } catch (e) {
      return null;
    }
  }

  // Helper method to get bank by name
  Bank? getBankByName(String name) {
    try {
      return data.firstWhere((bank) =>
      bank.name.toLowerCase() == name.toLowerCase()
      );
    } catch (e) {
      return null;
    }
  }
}

class Bank {
  final String code;
  final String name;

  Bank({
    required this.code,
    required this.name,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
  };

  // Helper methods
  String get displayName => name.trim();

  String get formattedCode => code.padLeft(6, '0');

  // Get bank icon/logo asset path (you can add your bank logos)
  // String get iconAsset {
  //   final bankName = name.toLowerCase();
  //   if (bankName.contains('access')) return 'assets/banks/access.png';
  //   if (bankName.contains('zenith')) return 'assets/banks/zenith.png';
  //   if (bankName.contains('uba')) return 'assets/banks/uba.png';
  //   if (bankName.contains('first bank')) return 'assets/banks/firstbank.png';
  //   if (bankName.contains('gtb')) return 'assets/banks/gtb.png';
  //   if (bankName.contains('ecobank')) return 'assets/banks/ecobank.png';
  //   if (bankName.contains('fidelity')) return 'assets/banks/fidelity.png';
  //   if (bankName.contains('union')) return 'assets/banks/union.png';
  //   if (bankName.contains('stanbic')) return 'assets/banks/stanbic.png';
  //   if (bankName.contains('polaris')) return 'assets/banks/polaris.png';
  //   if (bankName.contains('fcmb')) return 'assets/banks/fcmb.png';
  //   if (bankName.contains('sterling')) return 'assets/banks/sterling.png';
  //   if (bankName.contains('wema')) return 'assets/banks/wema.png';
  //   if (bankName.contains('keystone')) return 'assets/banks/keystone.png';
  //   if (bankName.contains('unity')) return 'assets/banks/unity.png';
  //   if (bankName.contains('jaiz')) return 'assets/banks/jaiz.png';
  //   if (bankName.contains('suntrust')) return 'assets/banks/suntrust.png';
  //   if (bankName.contains('providus')) return 'assets/banks/providus.png';
  //   if (bankName.contains('titan')) return 'assets/banks/titan.png';
  //   if (bankName.contains('taj')) return 'assets/banks/taj.png';
  //   if (bankName.contains('globus')) return 'assets/banks/globus.png';
  //   if (bankName.contains('lotus')) return 'assets/banks/lotus.png';
  //   if (bankName.contains('parallex')) return 'assets/banks/parallex.png';
  //   if (bankName.contains('signature')) return 'assets/banks/signature.png';
  //   return 'assets/banks/default.png';
  // }

  // Categorize banks by type
  BankType get type {
    final bankName = name.toLowerCase();
    if (bankName.contains('microfinance') || bankName.contains('mfb')) {
      return BankType.microfinance;
    } else if (bankName.contains('merchant')) {
      return BankType.merchant;
    } else if (bankName.contains('finance') && !bankName.contains('microfinance')) {
      return BankType.financeCompany;
    } else if (bankName.contains('mortgage')) {
      return BankType.mortgage;
    } else if (bankName.contains('savings') || bankName.contains('loans')) {
      return BankType.savingsAndLoans;
    } else {
      return BankType.commercial;
    }
  }

  // Get bank category color
  Color get categoryColor {
    switch (type) {
      case BankType.commercial:
        return Colors.blue;
      case BankType.microfinance:
        return Colors.green;
      case BankType.merchant:
        return Colors.orange;
      case BankType.financeCompany:
        return Colors.purple;
      case BankType.mortgage:
        return Colors.red;
      case BankType.savingsAndLoans:
        return Colors.teal;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Bank && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() {
    return 'Bank{code: $code, name: $name}';
  }
}

enum BankType {
  commercial,
  microfinance,
  merchant,
  financeCompany,
  mortgage,
  savingsAndLoans,
}

// Extension for BankType
extension BankTypeExtension on BankType {
  String get displayName {
    switch (this) {
      case BankType.commercial:
        return 'Commercial Bank';
      case BankType.microfinance:
        return 'Microfinance Bank';
      case BankType.merchant:
        return 'Merchant Bank';
      case BankType.financeCompany:
        return 'Finance Company';
      case BankType.mortgage:
        return 'Mortgage Bank';
      case BankType.savingsAndLoans:
        return 'Savings & Loans';
    }
  }
}