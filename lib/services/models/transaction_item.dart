class TransactionItem {
  final String txnRef;
  final String? refs;
  final String terminalName;
  final double amount;
  final DateTime date;

  TransactionItem({
    required this.txnRef,
    required this.terminalName,
    required this.amount,
    required this.date,
    this.refs,
  });
}
