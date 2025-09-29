import '../pigmentation.dart';

class BankDepositHistoryResponse {
  final List<BankDepositItem> data;
  final Pagination pagination;

  BankDepositHistoryResponse({
    required this.data,
    required this.pagination,
  });

  factory BankDepositHistoryResponse.fromJson(Map<String, dynamic> json) {
    return BankDepositHistoryResponse(
      data: (json['data'] as List)
          .map((e) => BankDepositItem.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class BankDepositItem {
  final String depositedAmount;
  final String txnChargesAmount;
  final String amountAfterCharges;
  final String beneficiaryAccountNumber;
  final String beneficiaryAccountName;
  final String beneficiaryBankName;
  final String narration;
  final String txnRef;
  final DateTime txnDate;
  final String paymentReference;
  final DateTime paymentDate;
  final String senderBankName;
  final String senderAccountName;
  final String senderAccountNumber;
  final String zainboxCode;
  final DateTime createdAt;
  final String terminalId;
  final String terminalName;

  BankDepositItem({
    required this.depositedAmount,
    required this.txnChargesAmount,
    required this.amountAfterCharges,
    required this.beneficiaryAccountNumber,
    required this.beneficiaryAccountName,
    required this.beneficiaryBankName,
    required this.narration,
    required this.txnRef,
    required this.txnDate,
    required this.paymentReference,
    required this.paymentDate,
    required this.senderBankName,
    required this.senderAccountName,
    required this.senderAccountNumber,
    required this.zainboxCode,
    required this.createdAt,
    required this.terminalId,
    required this.terminalName,
  });

  factory BankDepositItem.fromJson(Map<String, dynamic> json) {
    return BankDepositItem(
      depositedAmount: json['deposited_amount'],
      txnChargesAmount: json['txn_charges_amount'],
      amountAfterCharges: json['amount_after_charges'],
      beneficiaryAccountNumber: json['beneficiary_account_number'],
      beneficiaryAccountName: json['beneficiary_account_name'],
      beneficiaryBankName: json['beneficiary_bank_name'],
      narration: json['narration'],
      txnRef: json['txn_ref'],
      txnDate: DateTime.parse(json['txn_date']),
      paymentReference: json['payment_reference'],
      paymentDate: DateTime.parse(json['payment_date']),
      senderBankName: json['sender_bank_name'],
      senderAccountName: json['sender_account_name'],
      senderAccountNumber: json['sender_account_number'],
      zainboxCode: json['zainbox_code'],
      createdAt: DateTime.parse(json['created_at']),
      terminalId: json['terminal_id'],
      terminalName: json['terminal_name'],
    );
  }
}
