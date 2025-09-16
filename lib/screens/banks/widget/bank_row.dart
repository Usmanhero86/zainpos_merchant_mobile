import 'package:flutter/material.dart';

import '../model/bank_model.dart';
import 'circular_percentage_bar.dart';

class BankRow extends StatelessWidget {
  final BankSuccessRate rate;

  const BankRow({
    super.key,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white
        // border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              rate.bank,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: CircularPercentageBar(percentage: rate.mcard),
          ),
          Expanded(
            child: CircularPercentageBar(percentage: rate.verve),
          ),
          Expanded(
            child: CircularPercentageBar(percentage: rate.visa),
          ),
        ],
      ),
    );
  }
}