import 'package:flutter/material.dart';
import '../../../services/models/response_model/home_response.dart';
import '../../../widgets/build_transaction_card.dart';

List<Widget> transactionsList(List<RecentTransaction> transactions) {
  return transactions.map((transaction) {
    final date = _parseDate(transaction.transactionDate);
    final amount = _parseAmount(transaction.amount);
    final balance = _parseAmount(transaction.settledAmount);

    return Column(
      children: [
        BuildTransactionCard(
          status: transaction.status,
          reference: transaction.transactionReference,
          terminal: transaction.terminalName,
          type: transaction.txnType,
          date: date.toString(),
          amount: amount.toString(),
          balance: balance.toString(),
        ),
      ],
    );
  }).toList();
}

DateTime _parseDate(String dateString) {
  try {
    if (dateString.contains('+')) {
      return DateTime.parse(dateString.split('+').first.trim());
    }
    return DateTime.parse(dateString);
  } catch (e) {
    return DateTime.now();
  }
}

double _parseAmount(String amountString) {
  try {
    // Remove any currency symbols or commas, then parse
    final cleaned = amountString.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  } catch (e) {
    return 0.0;
  }
}