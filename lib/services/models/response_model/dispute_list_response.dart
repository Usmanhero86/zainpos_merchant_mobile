import 'dart:convert';

class DisputeListResponse {
  final List<DisputeItem> data;

  DisputeListResponse({required this.data});

  factory DisputeListResponse.fromJson(Map<String, dynamic> json) {
    return DisputeListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => DisputeItem.fromJson(e))
          .toList(),
    );
  }

  factory DisputeListResponse.fromRawJson(String str) =>
      DisputeListResponse.fromJson(json.decode(str));
}

class DisputeItem {
  final String disputeId;
  final String terminalId;
  final String cardType;
  final String cardPan;
  final String txnRrn;
  final String txnReference;
  final DateTime txnDate;
  final String txnAmount;
  final String txnResponseMessage;
  final String customerAccountName;
  final String customerAccountNumber;
  final String customerBankName;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  DisputeItem({
    required this.disputeId,
    required this.terminalId,
    required this.cardType,
    required this.cardPan,
    required this.txnRrn,
    required this.txnReference,
    required this.txnDate,
    required this.txnAmount,
    required this.txnResponseMessage,
    required this.customerAccountName,
    required this.customerAccountNumber,
    required this.customerBankName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DisputeItem.fromJson(Map<String, dynamic> json) {
    return DisputeItem(
      disputeId: json['dispute_id'] ?? '',
      terminalId: json['terminal_id'] ?? '',
      cardType: json['card_type'] ?? '',
      cardPan: json['card_pan'] ?? '',
      txnRrn: json['txn_rrn'] ?? '',
      txnReference: json['txn_reference'] ?? '',
      txnDate: DateTime.parse(json['txn_date']),
      txnAmount: json['txn_amount'] ?? '',
      txnResponseMessage: json['txn_response_message'] ?? '',
      customerAccountName: json['customer_account_name'] ?? '',
      customerAccountNumber: json['customer_account_number'] ?? '',
      customerBankName: json['customer_bank_name'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
