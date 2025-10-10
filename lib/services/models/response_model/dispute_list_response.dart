import 'dart:convert';

class DisputeListResponse {
  final List<DisputeModel> data;
  final Pagination pagination;

  DisputeListResponse({
    required this.data,
    required this.pagination,
  });

  factory DisputeListResponse.fromJson(Map<String, dynamic> json) {
    return DisputeListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => DisputeModel.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  factory DisputeListResponse.fromRawJson(String str) =>
      DisputeListResponse.fromJson(json.decode(str));
}

class DisputeModel {
  final String disputeId;
  final String terminalId;
  final String cardType;
  final String cardPan;
  final String txnRrn;
  final String txnReference;
  final DateTime txnDate;
  final double txnAmount;
  final String txnResponseMessage;
  final String customerAccountName;
  final String customerAccountNumber;
  final String customerBankName;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  DisputeModel({
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

  factory DisputeModel.fromJson(Map<String, dynamic> json) {
    return DisputeModel(
      disputeId: json['dispute_id'] ?? '',
      terminalId: json['terminal_id'] ?? '',
      cardType: json['card_type'] ?? '',
      cardPan: json['card_pan'] ?? '',
      txnRrn: json['txn_rrn'] ?? '',
      txnReference: json['txn_reference'] ?? '',
      txnDate: DateTime.parse(json['txn_date']),
      txnAmount: _parseAmount(json['txn_amount']),
      txnResponseMessage: json['txn_response_message'] ?? '',
      customerAccountName: json['customer_account_name'] ?? '',
      customerAccountNumber: json['customer_account_number'] ?? '',
      customerBankName: json['customer_bank_name'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// Safely parse txn_amount (handles commas like "1,000")
  static double _parseAmount(dynamic amount) {
    if (amount == null) return 0.0;
    final str = amount.toString().replaceAll(',', '');
    return double.tryParse(str) ?? 0.0;
  }
}

class Pagination {
  final int totalCount;
  final int page;
  final int limit;

  Pagination({
    required this.totalCount,
    required this.page,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalCount: json['total_count'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 25,
    );
  }
}
