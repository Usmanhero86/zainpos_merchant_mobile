class Transaction {
  final String status;
  final String terminal;
  final double amount;
  final String date;
  final String reference;

  Transaction({
    required this.status,
    required this.terminal,
    required this.amount,
    required this.date,
    required this.reference,
  });
}
