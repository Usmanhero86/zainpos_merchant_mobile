import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/home/home_screen.dart';
import 'package:zainpos_merchant_mobile/widgets/transfer_success_widget.dart';

class LoanSuccess extends StatelessWidget {
  const LoanSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    // dynamic spacing
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.05;
    final amount = 200000;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500, // prevents it from stretching too wide on tablets
              ),
              child: TransferSuccessWidget(
                amount: amount.toDouble(),
                recipient: '',
                title: '',
                subTitle: '',
                onClose: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
