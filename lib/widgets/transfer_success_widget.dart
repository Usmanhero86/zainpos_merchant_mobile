import 'package:flutter/material.dart';

class TransferSuccessWidget extends StatelessWidget {
  final double? amount;
  final String? recipient;
  final String? bankName;
  final String? accountNumber;
  final String? transactionReference;
  final String? narration;
  final DateTime? transactionDate;
  final VoidCallback onClose;
  final VoidCallback? onShareReceipt;
  final VoidCallback? onViewTransaction;
  final double? containerHeight;
  final Color? iconColor;
  final Color? buttonColor;
  final Color? textColor;
  final Color? backgroundColor;
  final String title;
  final String subTitle;
  final bool showTransactionDetails;
  final bool showActionButtons;

  const TransferSuccessWidget({
    super.key,
    this.amount,
    this.recipient,
    this.bankName,
    this.accountNumber,
    this.transactionReference,
    this.narration,
    this.transactionDate,
    required this.onClose,
    this.onShareReceipt,
    this.onViewTransaction,
    this.containerHeight,
    this.iconColor,
    this.buttonColor,
    this.textColor,
    this.backgroundColor,
    required this.title,
    required this.subTitle,
    this.showTransactionDetails = true,
    this.showActionButtons = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Fixed height: exactly 1/3 of screen
    final containerHeight = screenHeight / 3;

    // Calculate responsive sizes based on container height
    final iconSize = containerHeight * 0.2; // 20% of container height
    final titleFontSize = containerHeight * 0.1; // 10% of container height
    final subtitleFontSize = containerHeight * 0.07; // 7% of container height
    final detailFontSize = containerHeight * 0.06; // 6% of container height
    final buttonFontSize = containerHeight * 0.07; // 7% of container height
    final iconButtonSize = containerHeight * 0.08; // 8% of container height

    // Calculate responsive padding and spacing
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = containerHeight * 0.03;
    final smallSpacing = containerHeight * 0.01;
    final mediumSpacing = containerHeight * 0.02;
    final largeSpacing = containerHeight * 0.03;

    return Container(
      height: containerHeight, // Exactly 1/3 of screen height
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        color: backgroundColor ?? Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: SingleChildScrollView( // Allow scrolling for overflow content
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: screenWidth * 0.1,
                height: containerHeight * 0.01,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            SizedBox(height: mediumSpacing),

            // Success Icon
            Icon(
              Icons.check_circle,
              size: iconSize.clamp(24, 48), // Min 24, max 48
              color: iconColor ?? Colors.green.shade700,
            ),
            SizedBox(height: smallSpacing),

            // Custom Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize.clamp(14, 20), // Min 14, max 20
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.black,
              ),
            ),
            SizedBox(height: smallSpacing / 2),

            // Custom Subtitle
            Text(
              subTitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: subtitleFontSize.clamp(12, 16), // Min 12, max 16
                color: textColor?.withOpacity(0.7) ?? Colors.grey.shade600,
              ),
            ),

            SizedBox(height: mediumSpacing),

            // Transaction Details - Compact version for 1/3 height
            if (showTransactionDetails && _hasTransactionDetails()) ...[
              _buildCompactTransactionDetails(
                  screenWidth,
                  containerHeight,
                  detailFontSize
              ),
              SizedBox(height: smallSpacing),
            ],

            // Only show basic amount and recipient if details are not shown
            if (!showTransactionDetails && amount != null && recipient != null) ...[
              Column(
                children: [
                  Text(
                    'You have successfully sent',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: detailFontSize.clamp(12, 14),
                      color: textColor?.withOpacity(0.7) ?? Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: smallSpacing / 2),
                  Text(
                    '₦${_formatAmount(amount!)} to $recipient',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: detailFontSize.clamp(12, 14),
                      fontWeight: FontWeight.w500,
                      color: textColor ?? Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: mediumSpacing),
            ],

            // Action Buttons - Compact version
            if (showActionButtons && (onShareReceipt != null || onViewTransaction != null)) ...[
              _buildCompactActionButtons(screenWidth, containerHeight, buttonFontSize, iconButtonSize),
              SizedBox(height: smallSpacing),
            ],

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: buttonColor ?? Colors.blue,
                  side: BorderSide(color: buttonColor ?? Colors.blue, width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: containerHeight * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: buttonColor ?? Colors.blue,
                    fontSize: buttonFontSize.clamp(14, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactTransactionDetails(double screenWidth, double containerHeight, double fontSize) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(containerHeight * 0.02),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Details',
            style: TextStyle(
              fontSize: fontSize.clamp(12, 14),
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.black,
            ),
          ),
          SizedBox(height: containerHeight * 0.01),
          if (amount != null)
            _buildCompactDetailRow('Amount', '₦${_formatAmount(amount!)}', fontSize),
          if (recipient != null)
            _buildCompactDetailRow('Recipient', recipient!, fontSize),
          if (bankName != null)
            _buildCompactDetailRow('Bank', bankName!, fontSize),
          if (accountNumber != null)
            _buildCompactDetailRow('Account', _maskAccountNumber(accountNumber!), fontSize),
        ],
      ),
    );
  }

  Widget _buildCompactDetailRow(String label, String value, double fontSize) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize.clamp(10, 12),
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: fontSize.clamp(10, 12),
                fontWeight: FontWeight.w400,
                color: textColor ?? Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactActionButtons(double screenWidth, double containerHeight, double fontSize, double iconSize) {
    return Row(
      children: [
        if (onShareReceipt != null) ...[
          Expanded(
            child: TextButton.icon(
              onPressed: onShareReceipt,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: containerHeight * 0.01),
              ),
              icon: Icon(
                Icons.share,
                size: iconSize.clamp(16, 20),
                color: buttonColor ?? Colors.blue,
              ),
              label: Text(
                'Share Receipt',
                style: TextStyle(
                  fontSize: fontSize.clamp(12, 14),
                  color: buttonColor ?? Colors.blue,
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
        ],
        if (onViewTransaction != null) ...[
          Expanded(
            child: TextButton.icon(
              onPressed: onViewTransaction,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: containerHeight * 0.01),
              ),
              icon: Icon(
                Icons.receipt,
                size: iconSize.clamp(16, 20),
                color: buttonColor ?? Colors.blue,
              ),
              label: Text(
                'View Details',
                style: TextStyle(
                  fontSize: fontSize.clamp(12, 14),
                  color: buttonColor ?? Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  bool _hasTransactionDetails() {
    return amount != null ||
        recipient != null ||
        bankName != null ||
        accountNumber != null ||
        transactionReference != null;
  }

  String _maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    return '${'*' * (accountNumber.length - 4)}${accountNumber.substring(accountNumber.length - 4)}';
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Extension for clamping values
extension Clamp on double {
  double clamp(double min, double max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}