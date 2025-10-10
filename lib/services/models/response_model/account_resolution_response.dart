import 'dart:convert';

class AccountResolutionResponse {
  final String code;
  final AccountData data;
  final String description;
  final String status;

  AccountResolutionResponse({
    required this.code,
    required this.data,
    required this.description,
    required this.status,
  });

  factory AccountResolutionResponse.fromJson(Map<String, dynamic> json) {
    return AccountResolutionResponse(
      code: json['code'] ?? '',
      data: AccountData.fromJson(json['data'] ?? {}),
      description: json['description'] ?? '',
      status: json['status'] ?? '',
    );
  }

  factory AccountResolutionResponse.fromRawJson(String str) =>
      AccountResolutionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    'code': code,
    'data': data.toJson(),
    'description': description,
    'status': status,
  };

  bool get isSuccess => code == '00';
}

class AccountData {
  final String accountName;
  final String accountNumber;
  final String bankCode;
  final String? bankName;

  AccountData({
    required this.accountName,
    required this.accountNumber,
    required this.bankCode,
    this.bankName,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      accountName: (json['accountName'] as String?)?.trim() ?? '',
      accountNumber: json['accountNumber'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'],
    );
  }

  Map<String, dynamic> toJson() => {
    'accountName': accountName,
    'accountNumber': accountNumber,
    'bankCode': bankCode,
    'bankName': bankName,
  };

  // Helper method to clean up the account name (remove extra spaces)
  String get cleanedAccountName {
    return accountName.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  // Helper method to get just the name without the prefix if present
  String get displayAccountName {
    final name = cleanedAccountName;
    if (name.contains('/')) {
      return name.split('/').last.trim();
    }
    return name;
  }
}