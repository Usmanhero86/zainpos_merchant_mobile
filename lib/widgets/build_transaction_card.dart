import 'package:flutter/material.dart';

class BuildTransactionCard extends StatelessWidget {
  const BuildTransactionCard({
    super.key,
    required this.status,
    required this.reference,
    required this.amount,
    required this.balance,
    required this.terminal,
    required this.type,
    required this.date,
  });

  final String status;
  final String reference;
  final String amount;
  final String balance;
  final String terminal;
  final String type;
  final String date;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$status - $reference',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: status == 'SUCCESS' ? Colors.green : Colors.orange,
                  ),
                ),
              ),
              // if (amount != null)
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color:  Colors.black,
                  ),
                ),
            ],
          ),
          // if (balance != null)
          //   Padding(
          //     padding: EdgeInsets.only(top: screenWidth * 0.01),
          //     child: Text(
          //       balance,
          //       style: TextStyle(
          //         fontSize: screenWidth * 0.038,
          //         color:  Color(0xFF0052cc),
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // SizedBox(height: screenWidth * 0.02),
          Text(
            terminal,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.035,
              color:  Colors.black,
            ),
          ),
          SizedBox(height: screenWidth * 0.01),
          Row(
            children: [
              Text(
                type,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color:  Colors.grey,
                ),
              ),
              SizedBox(width: 8),
              Text(
                date,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color:  Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
