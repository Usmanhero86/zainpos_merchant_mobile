class DashboardResponse {
  final MonthlyTransactions monthlyTransactions;
  final List<Transaction> recentTransactions;

  DashboardResponse({
    required this.monthlyTransactions,
    required this.recentTransactions,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      monthlyTransactions: MonthlyTransactions.fromJson(
        json['monthly_transactions'] as Map<String, dynamic>,
      ),
      recentTransactions: (json['recent_transactions'] as List<dynamic>)
          .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthly_transactions': monthlyTransactions.toJson(),
      'recent_transactions':
      recentTransactions.map((t) => t.toJson()).toList(),
    };
  }
}

class MonthlyTransactions {
  final double totalBankDeposit;
  final double totalCardPurchase;

  MonthlyTransactions({
    required this.totalBankDeposit,
    required this.totalCardPurchase,
  });

  factory MonthlyTransactions.fromJson(Map<String, dynamic> json) {
    return MonthlyTransactions(
      totalBankDeposit: (json['total_bank_deposit'] as num).toDouble(),
      totalCardPurchase: (json['total_card_purchase'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_bank_deposit': totalBankDeposit,
      'total_card_purchase': totalCardPurchase,
    };
  }
}

/// Reuse the Transaction model from earlier
class Transaction {
  final String amount;
  final String settledAmount;
  final String status;
  final String terminalId;
  final String terminalName;
  final DateTime transactionDate;
  final String transactionReference;
  final String txnType;

  Transaction({
    required this.amount,
    required this.settledAmount,
    required this.status,
    required this.terminalId,
    required this.terminalName,
    required this.transactionDate,
    required this.transactionReference,
    required this.txnType,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'] as String,
      settledAmount: json['settled_amount'] as String,
      status: json['status'] as String,
      terminalId: json['terminal_id'] as String,
      terminalName: json['terminal_name'] as String,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      transactionReference: json['transaction_reference'] as String,
      txnType: json['txn_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'settled_amount': settledAmount,
      'status': status,
      'terminal_id': terminalId,
      'terminal_name': terminalName,
      'transaction_date': transactionDate.toIso8601String(),
      'transaction_reference': transactionReference,
      'txn_type': txnType,
    };
  }
}
