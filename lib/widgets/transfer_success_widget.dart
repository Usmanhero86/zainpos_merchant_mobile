import 'package:flutter/material.dart';

class TransferSuccessWidget extends StatelessWidget {
  final double? amount; // Make optional
  final String? recipient; // Make optional
  final VoidCallback onClose;
  final double? containerHeight;
  final Color? iconColor;
  final Color? buttonColor;
  final Color? textColor;
  final String title; // Add title parameter
  final String subTitle; // Add subtitle parameter

  const TransferSuccessWidget({
    super.key,
    this.amount,
    this.recipient,
    required this.onClose,
    this.containerHeight,
    this.iconColor,
    this.buttonColor,
    this.textColor,
    required this.title, // Require title
    required this.subTitle, // Require subtitle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
           SizedBox(height: 20),

          // Success Icon
          Icon(
            Icons.check_circle,
            size: 80,
            color: iconColor ?? Colors.green.shade700,
          ),
           SizedBox(height: 15),

          // Custom Title
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.black,
            ),
          ),
           SizedBox(height: 15),

          // Custom Subtitle
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: textColor?.withOpacity(0.7) ?? Colors.grey,
            ),
          ),

          // Only show amount and recipient if they are provided
          if (amount != null && recipient != null) ...[
             SizedBox(height: 15),
            Column(
              children: [
                Text(
                  'You have successfully sent',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor?.withOpacity(0.7) ?? Colors.grey,
                  ),
                ),
                 SizedBox(height: 8),
                Text(
                  'N${_formatAmount(amount!)} to $recipient',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor?.withOpacity(0.7) ?? Colors.grey,
                  ),
                ),
              ],
            ),
          ],

           SizedBox(height: 10),

          // Close Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: buttonColor ?? Colors.blue,
                side: BorderSide(color: buttonColor ?? Colors.blue),
                padding:  EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Close',
                style: TextStyle(
                  color: buttonColor ?? Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }
}