import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/widgets/transfer_success_widget.dart';
import '../../widgets/build_dropdown.dart';
import '../../widgets/input_field.dart';

class LoanRequestScreen extends StatefulWidget {
  const LoanRequestScreen({super.key});

  @override
  State<LoanRequestScreen> createState() => _LoanRequestScreenState();
}

class _LoanRequestScreenState extends State<LoanRequestScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  String? _selectedMoratorium;
  String? _selectedSettlementFrequency;

  // Options for dropdowns
  final List<String> moratoriumOptions = [
    'No Moratorium',
    '1 Month',
    '2 Months',
    '3 Months',
    '6 Months'
  ];

  final List<String> settlementOptions = [
    'Monthly',
    'Quarterly',
    'Bi-Annually',
    'Annually'
  ];

  // Method to show the transfer success bottom sheet
  void showTransferSuccessBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return TransferSuccessWidget(
          onClose: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          title: 'Loan Request is being processed',
          subTitle:
          'This will typically take 1-3 hours,\nwe will notify you when it has been processed',
        );
      },
    );
  }

  void submitLoanRequest() {
    showTransferSuccessBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final horizontalPadding = screenWidth * 0.04;
    final verticalSpacing = screenHeight * 0.02;
    final titleFontSize = screenWidth * 0.06;
    final inputFontSize = screenWidth * 0.04;
    final buttonFontSize = screenWidth * 0.045;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: screenWidth * 0.06),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Back to Loans',
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.045,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Request Loan',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: verticalSpacing * 2),

            // Loan Amount Input
            InputField(
              hintText: 'Enter Loan Amount',
              controller: _amountController,
              keyboardType: TextInputType.number,
              fontSize: inputFontSize,
              prefix: Text(
                '₦',
                style: TextStyle(
                  fontSize: inputFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            SizedBox(height: verticalSpacing),

            // Moratorium Dropdown
            BuildDropdown(
              hint: 'Moratorium',
              value: _selectedMoratorium,
              items: moratoriumOptions,
              onChanged: (value) {
                setState(() {
                  _selectedMoratorium = value;
                });
              },
            ),
            SizedBox(height: verticalSpacing),

            // Settlement Frequency Dropdown
            BuildDropdown(
              hint: 'Select Settlement Frequency',
              value: _selectedSettlementFrequency,
              items: settlementOptions,
              onChanged: (value) {
                setState(() {
                  _selectedSettlementFrequency = value;
                });
              },
            ),
            SizedBox(height: verticalSpacing),

            // Purpose of Loan Input
            InputField(
              hintText: 'Enter Purpose of loan',
              controller: _purposeController,
              keyboardType: TextInputType.text,
              fontSize: inputFontSize,
              maxLines: 3,
            ),
            SizedBox(height: verticalSpacing * 2),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitLoanRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                ),
                child: Text(
                  'Request Loan',
                  style: TextStyle(
                    fontSize: buttonFontSize,
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


}
