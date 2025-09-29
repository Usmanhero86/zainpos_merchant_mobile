import 'package:flutter/material.dart';

class LoanAmountCard extends StatelessWidget {
  final String amount;
  final String label;
  final Color? amountColor;
  final Color? labelColor;
  final Color? cardColor;
  final Color? borderColor;

  const LoanAmountCard({
    super.key,
    required this.amount,
     required this.label,
    this.amountColor,
    this.labelColor,
    this.cardColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor ?? Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor ?? Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Text(
            amount,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: amountColor ?? Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: labelColor ?? Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}