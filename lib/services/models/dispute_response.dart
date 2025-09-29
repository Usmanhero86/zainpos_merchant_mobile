class DisputeResponse {
  final List<Dispute> data;
  final DisputePagination pagination;

  DisputeResponse({
    required this.data,
    required this.pagination,
  });

  factory DisputeResponse.fromJson(Map<String, dynamic> json) {
    return DisputeResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Dispute.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: DisputePagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'pagination': pagination.toJson(),
  };
}

/// Individual dispute item
class Dispute {
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

  Dispute({
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

  factory Dispute.fromJson(Map<String, dynamic> json) {
    return Dispute(
      disputeId: json['dispute_id'] ?? '',
      terminalId: json['terminal_id'] ?? '',
      cardType: json['card_type'] ?? '',
      cardPan: json['card_pan'] ?? '',
      txnRrn: json['txn_rrn'] ?? '',
      txnReference: json['txn_reference'] ?? '',
      txnDate: DateTime.tryParse(json['txn_date'] ?? '') ?? DateTime.now(),
      txnAmount: json['txn_amount'] ?? '',
      txnResponseMessage: json['txn_response_message'] ?? '',
      customerAccountName: json['customer_account_name'] ?? '',
      customerAccountNumber: json['customer_account_number'] ?? '',
      customerBankName: json['customer_bank_name'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'dispute_id': disputeId,
    'terminal_id': terminalId,
    'card_type': cardType,
    'card_pan': cardPan,
    'txn_rrn': txnRrn,
    'txn_reference': txnReference,
    'txn_date': txnDate.toIso8601String(),
    'txn_amount': txnAmount,
    'txn_response_message': txnResponseMessage,
    'customer_account_name': customerAccountName,
    'customer_account_number': customerAccountNumber,
    'customer_bank_name': customerBankName,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

/// Pagination object
class DisputePagination {
  final int totalCount;
  final int page;
  final int limit;

  DisputePagination({
    required this.totalCount,
    required this.page,
    required this.limit,
  });

  factory DisputePagination.fromJson(Map<String, dynamic> json) {
    return DisputePagination(
      totalCount: json['total_count'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 25,
    );
  }

  Map<String, dynamic> toJson() => {
    'total_count': totalCount,
    'page': page,
    'limit': limit,
  };
}
