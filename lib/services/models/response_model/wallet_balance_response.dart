class WalletBalanceResponse {
  final bool status;
  final String message;
  final WalletBalanceData? data;

  WalletBalanceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
    return WalletBalanceResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? WalletBalanceData.fromJson(json['data'])
          : null,
    );
  }
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
      balanceAmount: double.tryParse(json['balance_amount'].toString()) ?? 0.0,
      bankName: json['bank_name'] ?? '',
      currency: json['currency'] ?? 'NGN',
    );
  }
}
