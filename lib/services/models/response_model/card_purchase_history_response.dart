import '../pigmentation.dart';

class CardPurchaseHistoryResponse {
  final List<CardPurchaseItem> data;
  final Pagination pagination;

  CardPurchaseHistoryResponse({
    required this.data,
    required this.pagination,
  });

  factory CardPurchaseHistoryResponse.fromJson(Map<String, dynamic> json) {
    return CardPurchaseHistoryResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CardPurchaseItem.fromJson(e))
          .toList() ?? [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  // Helper methods for pagination
  bool get hasMoreData {
    return data.length >= pagination.limit &&
        (pagination.totalCount > (pagination.page * pagination.limit));
  }

  int get nextPage => pagination.page + 1;
}
// REMOVE THE EXTRA CLOSING BRACE FROM HERE

class CardPurchaseItem {
  final String terminalId;
  final String terminalName;
  final String cardPan;
  final String cardType;
  final String txnStatus;
  final DateTime txnDate;
  final String txnRrn;
  final String amount;
  final String amountAfterCharges;
  final String charges;
  final String txnRef;
  final String responseCode;
  final bool zainpayStatus;
  final String txnStan;
  final String cardAid;
  final String cardTrack2Data;

  CardPurchaseItem({
    required this.terminalId,
    required this.terminalName,
    required this.cardPan,
    required this.cardType,
    required this.txnStatus,
    required this.txnDate,
    required this.txnRrn,
    required this.amount,
    required this.amountAfterCharges,
    required this.charges,
    required this.txnRef,
    required this.responseCode,
    required this.zainpayStatus,
    required this.txnStan,
    required this.cardAid,
    required this.cardTrack2Data,
  });

  factory CardPurchaseItem.fromJson(Map<String, dynamic> json) {
    return CardPurchaseItem(
      terminalId: json['terminal_id'],
      terminalName: json['terminal_name'],
      cardPan: json['card_pan'],
      cardType: json['card_type'],
      txnStatus: json['txn_status'],
      txnDate: DateTime.parse(json['txn_date']),
      txnRrn: json['txn_rrn'],
      amount: json['amount'],
      amountAfterCharges: json['amount_after_charges'],
      charges: json['charges'],
      txnRef: json['txn_ref'],
      responseCode: json['response_code'],
      zainpayStatus: json['zainpay_status'] ?? false,
      txnStan: json['txn_stan'],
      cardAid: json['card_aid'],
      cardTrack2Data: json['card_track2_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'terminal_id': terminalId,
      'terminal_name': terminalName,
      'card_pan': cardPan,
      'card_type': cardType,
      'txn_status': txnStatus,
      'txn_date': txnDate.toIso8601String(),
      'txn_rrn': txnRrn,
      'amount': amount,
      'amount_after_charges': amountAfterCharges,
      'charges': charges,
      'txn_ref': txnRef,
      'response_code': responseCode,
      'zainpay_status': zainpayStatus,
      'txn_stan': txnStan,
      'card_aid': cardAid,
      'card_track2_data': cardTrack2Data,
    };
  }
}