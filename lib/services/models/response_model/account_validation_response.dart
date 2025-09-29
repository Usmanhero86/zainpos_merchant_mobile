import 'dart:convert';

AccountValidationResponse accountValidationResponseFromJson(String str) =>
    AccountValidationResponse.fromJson(json.decode(str));

String accountValidationResponseToJson(AccountValidationResponse data) =>
    json.encode(data.toJson());

class AccountValidationResponse {
  final String code;
  final String description;
  final String status;
  final AccountData data;

  AccountValidationResponse({
    required this.code,
    required this.description,
    required this.status,
    required this.data,
  });

  factory AccountValidationResponse.fromJson(Map<String, dynamic> json) {
    return AccountValidationResponse(
      code: json['code'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      data: AccountData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'description': description,
    'status': status,
    'data': data.toJson(),
  };
}

class AccountData {
  final String accountName;
  final String accountNumber;
  final String bankCode;
  final String? bankName; // nullable

  AccountData({
    required this.accountName,
    required this.accountNumber,
    required this.bankCode,
    this.bankName,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      accountName: json['accountName'] as String,
      accountNumber: json['accountNumber'] as String,
      bankCode: json['bankCode'] as String,
      bankName: json['bankName'] as String?, // may be null
    );
  }

  Map<String, dynamic> toJson() => {
    'accountName': accountName,
    'accountNumber': accountNumber,
    'bankCode': bankCode,
    'bankName': bankName,
  };
}
