import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/home/home_screen.dart';
import 'package:zainpos_merchant_mobile/widgets/transfer_success_widget.dart';
import 'widget/back_space.dart';
import 'widget/number_button.dart';

class PinEntryScreen extends StatefulWidget {
  const PinEntryScreen({super.key});

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String _enteredPin = '';

  void _onNumberPressed(String number) {
    setState(() {
      if (_enteredPin.length < 4) {
        _enteredPin += number;
      } else {
        showTransferSuccessBottomSheet(context);
      }
    });
  }

  void onBackspacePressed() {
    setState(() {
      if (_enteredPin.isNotEmpty) {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      }
    });
  }

  void showTransferSuccessBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return TransferSuccessWidget(
          amount: 200000.00,
          recipient: 'Gidado Mustapha \n Enterprise',
          onClose: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          title: 'Transfer Successful',
          subTitle: '',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // -------- Responsive metrics --------
    final Size size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    final double headingFont = w * 0.06;
    final double subFont = w * 0.04;
    final double dotSize = w * 0.05;
    final double dotSpacing = w * 0.03;
    final double keypadSpacing = h * 0.025;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: h * 0.02),
                Text(
                  'Enter your PIN',
                  style: TextStyle(
                    fontSize: headingFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: h * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: Text(
                    'Enter your PIN to complete this transaction',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subFont,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: h * 0.05),

                // PIN dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: dotSpacing),
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index < _enteredPin.length
                            ? Colors.blue
                            : Colors.grey[300],
                      ),
                    );
                  }),
                ),
                SizedBox(height: h * 0.08),

                // Numeric keypad
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NumberButton(number: '1', onPressed: _onNumberPressed, size: w * 0.18),
                        NumberButton(number: '2', onPressed: _onNumberPressed, size: w * 0.18),
                        NumberButton(number: '3', onPressed: _onNumberPressed, size: w * 0.18),
                      ],
                    ),
                    SizedBox(height: keypadSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NumberButton(number: '4', onPressed: _onNumberPressed, size: w * 0.18),
                        NumberButton(number: '5', onPressed: _onNumberPressed, size: w * 0.18),
                        NumberButton(number: '6', onPressed: _onNumberPressed, size: w * 0.18),
                      ],
                    ),
                    SizedBox(height: keypadSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NumberButton(number: '7', onPressed: _onNumberPressed, size: w * 0.18),
                        NumberButton(number: '8', onPressed: _onNumberPressed, size: w * 0.18),
                        NumberButton(number: '9', onPressed: _onNumberPressed, size: w * 0.18),
                      ],
                    ),
                    SizedBox(height: keypadSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: w * 0.18, height: w * 0.18), // empty slot
                        NumberButton(number: '0', onPressed: _onNumberPressed, size: w * 0.18),
                        BackspaceButton(
                          onPressed: onBackspacePressed,
                          size: w * 0.18,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
