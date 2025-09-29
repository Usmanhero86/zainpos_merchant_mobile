class PayoutResponseModel {
  final List<PayoutTransferData> data;
  final Pagination pagination;

  PayoutResponseModel({required this.data, required this.pagination});

  factory PayoutResponseModel.fromJson(Map<String, dynamic> json) {
    return PayoutResponseModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => PayoutTransferData.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'pagination': pagination.toJson(),
  };
}

class PayoutTransferData {
  final String destinationAccountNumber;
  final String destinationAccountName;
  final String destinationBankName;
  final String destinationBankCode;
  final String sourceAccountNumber;
  final String narration;
  final String zainpayPaymentRef;
  final String txnRef;
  final String zainboxCode;
  final String amount;
  final String txnStatus;
  final DateTime txnDate;
  final String terminalId;
  final String terminalName;

  PayoutTransferData({
    required this.destinationAccountNumber,
    required this.destinationAccountName,
    required this.destinationBankName,
    required this.destinationBankCode,
    required this.sourceAccountNumber,
    required this.narration,
    required this.zainpayPaymentRef,
    required this.txnRef,
    required this.zainboxCode,
    required this.amount,
    required this.txnStatus,
    required this.txnDate,
    required this.terminalId,
    required this.terminalName,
  });

  factory PayoutTransferData.fromJson(Map<String, dynamic> json) {
    return PayoutTransferData(
      destinationAccountNumber: json['destination_account_number'] ?? '',
      destinationAccountName: json['destination_account_name'] ?? '',
      destinationBankName: json['destination_bank_name'] ?? '',
      destinationBankCode: json['destination_bank_code'] ?? '',
      sourceAccountNumber: json['source_account_number'] ?? '',
      narration: json['narration'] ?? '',
      zainpayPaymentRef: json['zainpay_payment_ref'] ?? '',
      txnRef: json['txn_ref'] ?? '',
      zainboxCode: json['zainbox_code'] ?? '',
      amount: json['amount'] ?? '',
      txnStatus: json['txn_status'] ?? '',
      txnDate: DateTime.tryParse(json['txn_date'] ?? '') ?? DateTime.now(),
      terminalId: json['terminal_id'] ?? '',
      terminalName: json['terminal_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'destination_account_number': destinationAccountNumber,
    'destination_account_name': destinationAccountName,
    'destination_bank_name': destinationBankName,
    'destination_bank_code': destinationBankCode,
    'source_account_number': sourceAccountNumber,
    'narration': narration,
    'zainpay_payment_ref': zainpayPaymentRef,
    'txn_ref': txnRef,
    'zainbox_code': zainboxCode,
    'amount': amount,
    'txn_status': txnStatus,
    'txn_date': txnDate.toIso8601String(),
    'terminal_id': terminalId,
    'terminal_name': terminalName,
  };
}

class Pagination {
  final int totalCount;
  final int page;
  final int limit;

  Pagination({required this.totalCount, required this.page, required this.limit});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalCount: json['total_count'] ?? 0,
    page: json['page'] ?? 1,
    limit: json['limit'] ?? 25,
  );

  Map<String, dynamic> toJson() => {
    'total_count': totalCount,
    'page': page,
    'limit': limit,
  };
}
