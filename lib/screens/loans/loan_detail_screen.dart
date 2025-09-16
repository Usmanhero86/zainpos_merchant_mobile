import 'package:flutter/material.dart';
import 'widgets/detail_item.dart';
import 'widgets/loan_amount_card.dart';
import 'widgets/payment_history_item.dart';

class LoanDetailsScreen extends StatelessWidget {
  const LoanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    // ✅ Responsive values
    final horizontalPadding = screenWidth * 0.04; // ~16 on small screens
    final verticalSpacing = screenHeight * 0.02;  // spacing blocks
    final headerFontSize = screenWidth * 0.06;    // ~24 on small screens
    final sectionFontSize = screenWidth * 0.045;  // ~18 on small screens
    final detailSpacing = screenHeight * 0.018;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: screenWidth * 0.06),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Back to Loans',
          style: TextStyle(fontSize: screenWidth * 0.045),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                'Loans',
                style: TextStyle(
                  fontSize: headerFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: verticalSpacing * 1.2),

            // Loan Amount Card
            const LoanAmountCard(),
            SizedBox(height: verticalSpacing * 1.2),

            // Details Section
            Text(
              'DETAILS',
              style: TextStyle(
                fontSize: sectionFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: detailSpacing),

            // Loan Details
            const DetailItem(title: 'Loan Balance', value: 'N22,500.00'),
            SizedBox(height: detailSpacing),

            const DetailItem(title: 'Next payment date', value: '2025-06-16'),
            SizedBox(height: detailSpacing),

            const DetailItem(title: 'Loan opening date', value: '2024-12-16'),
            SizedBox(height: detailSpacing),

            const DetailItem(title: 'Loan maturity date', value: '2025-12-16'),
            SizedBox(height: detailSpacing),

            const DetailItem(title: 'Tenure', value: '12 Months'),
            SizedBox(height: verticalSpacing * 1.5),

            // Payment History Section
            Text(
              'Payment History',
              style: TextStyle(
                fontSize: sectionFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: detailSpacing),

            // Payment History Items
            const PaymentHistoryItem(
              title: 'Loan Payment',
              date: '2024-02-16',
              amount: 'N12,500.00',
            ),
            SizedBox(height: detailSpacing),

            const PaymentHistoryItem(
              title: 'Loan Payment',
              date: '2024-01-16',
              amount: 'N12,500.00',
            ),
            SizedBox(height: verticalSpacing),
          ],
        ),
      ),
    );
  }
}
