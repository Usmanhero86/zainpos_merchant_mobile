// lib/services/models/response_model/home_response.dart
import 'package:flutter/material.dart';

class HomeResponse {
  final MonthlyTransactions monthlyTransactions;
  final List<RecentTransaction> recentTransactions;
  final List<Terminal> terminals;

  HomeResponse({
    required this.monthlyTransactions,
    required this.recentTransactions,
    required this.terminals,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      monthlyTransactions: MonthlyTransactions.fromJson(json['monthly_transactions']),
      recentTransactions: List<RecentTransaction>.from(
          json['recent_transactions'].map((x) => RecentTransaction.fromJson(x))
      ),
      terminals: List<Terminal>.from(
          json['terminals'].map((x) => Terminal.fromJson(x))
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'monthly_transactions': monthlyTransactions.toJson(),
    'recent_transactions': List<dynamic>.from(recentTransactions.map((x) => x.toJson())),
    'terminals': List<dynamic>.from(terminals.map((x) => x.toJson())),
  };
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
      totalBankDeposit: (json['total_bank_deposit'] as num?)?.toDouble() ?? 0.0,
      totalCardPurchase: (json['total_card_purchase'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'total_bank_deposit': totalBankDeposit,
    'total_card_purchase': totalCardPurchase,
  };
}

class RecentTransaction {
  final String amount;
  final String settledAmount;
  final String status;
  final String? terminalId;
  final String terminalName;
  final String transactionDate;
  final String transactionReference;
  final String txnType;

  RecentTransaction({
    required this.amount,
    required this.settledAmount,
    required this.status,
     this.terminalId,
    required this.terminalName,
    required this.transactionDate,
    required this.transactionReference,
    required this.txnType,
  });

  factory RecentTransaction.fromJson(Map<String, dynamic> json) {
    return RecentTransaction(
      amount: json['amount']?.toString() ?? '0',
      settledAmount: json['settled_amount']?.toString() ?? '0',
      status: json['status'] ?? 'Unknown',
      terminalId: json['terminal_id'] ?? '',
      terminalName: json['terminal_name'] ?? '',
      transactionDate: json['transaction_date'] ?? '',
      transactionReference: json['transaction_reference'] ?? '',
      txnType: json['txn_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'settled_amount': settledAmount,
    'status': status,
    'terminal_id': terminalId,
    'terminal_name': terminalName,
    'transaction_date': transactionDate,
    'transaction_reference': transactionReference,
    'txn_type': txnType,
  };

  // Helper methods
  double get amountDouble => double.tryParse(amount) ?? 0.0;
  double get settledAmountDouble => double.tryParse(settledAmount) ?? 0.0;

  String get formattedAmount => 'N${amountDouble.toStringAsFixed(2)}';
  String get formattedSettledAmount => 'N${settledAmountDouble.toStringAsFixed(2)}';

  DateTime get parsedDate {
    try {
      // Handle different date formats
      if (transactionDate.contains('+')) {
        return DateTime.parse(transactionDate.split('+').first);
      }
      return DateTime.parse(transactionDate);
    } catch (e) {
      return DateTime.now();
    }
  }

  String get formattedDate {
    final date = parsedDate;
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  IconData get transactionIcon {
    switch (txnType.toLowerCase()) {
      case 'card purchase':
        return Icons.credit_card;
      case 'bank transfer':
        return Icons.account_balance;
      default:
        return Icons.receipt;
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class Terminal {
  final String authCode;
  final String businessAddress;
  final String businessName;
  final String createdOn;
  final String id;
  final String imei;
  final bool isActive;
  final bool reprintEnabled;
  final bool status;
  final String terminalAddress;
  final String terminalId;
  final String terminalName;
  final bool transferEnabled;
  final String tsn;
  final String updatedOn;
  final bool viewBalanceEnabled;
  final String virtualAccountNumber;
  final String zainboxCode;

  Terminal({
    required this.authCode,
    required this.businessAddress,
    required this.businessName,
    required this.createdOn,
    required this.id,
    required this.imei,
    required this.isActive,
    required this.reprintEnabled,
    required this.status,
    required this.terminalAddress,
    required this.terminalId,
    required this.terminalName,
    required this.transferEnabled,
    required this.tsn,
    required this.updatedOn,
    required this.viewBalanceEnabled,
    required this.virtualAccountNumber,
    required this.zainboxCode,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      authCode: json['auth_code'] ?? '',
      businessAddress: json['business_address'] ?? '',
      businessName: json['business_name'] ?? '',
      createdOn: json['created_on'] ?? '',
      id: json['id'] ?? '',
      imei: json['imei'] ?? '',
      isActive: json['is_active'] ?? false,
      reprintEnabled: json['reprint_enabled'] ?? false,
      status: json['status'] ?? false,
      terminalAddress: json['terminal_address'] ?? '',
      terminalId: json['terminal_id'] ?? '',
      terminalName: json['terminal_name'] ?? '',
      transferEnabled: json['transfer_enabled'] ?? false,
      tsn: json['tsn'] ?? '',
      updatedOn: json['updated_on'] ?? '',
      viewBalanceEnabled: json['view_balance_enabled'] ?? false,
      virtualAccountNumber: json['virtual_account_number'] ?? '',
      zainboxCode: json['zainbox_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'auth_code': authCode,
    'business_address': businessAddress,
    'business_name': businessName,
    'created_on': createdOn,
    'id': id,
    'imei': imei,
    'is_active': isActive,
    'reprint_enabled': reprintEnabled,
    'status': status,
    'terminal_address': terminalAddress,
    'terminal_id': terminalId,
    'terminal_name': terminalName,
    'transfer_enabled': transferEnabled,
    'tsn': tsn,
    'updated_on': updatedOn,
    'view_balance_enabled': viewBalanceEnabled,
    'virtual_account_number': virtualAccountNumber,
    'zainbox_code': zainboxCode,
  };

  // Helper methods
  DateTime get parsedCreatedOn {
    try {
      return DateTime.parse(createdOn);
    } catch (e) {
      return DateTime.now();
    }
  }

  DateTime get parsedUpdatedOn {
    try {
      return DateTime.parse(updatedOn);
    } catch (e) {
      return DateTime.now();
    }
  }

  String get formattedCreatedOn {
    final date = parsedCreatedOn;
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedUpdatedOn {
    final date = parsedUpdatedOn;
    return '${date.day}/${date.month}/${date.year}';
  }
}