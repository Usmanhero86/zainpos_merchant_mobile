import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/home/home_screen.dart';
import 'package:zainpos_merchant_mobile/screens/pin/widget/build_transfer_summary.dart';
import 'package:zainpos_merchant_mobile/screens/pin/widget/complete_message.dart';
import 'package:zainpos_merchant_mobile/widgets/transfer_success_widget.dart';
import 'widget/back_space.dart';
import 'widget/number_button.dart';

class PinEntryScreen extends StatefulWidget {
  final Map<String, dynamic> transferData;

  const PinEntryScreen({super.key, required this.transferData});

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String _enteredPin = '';
  bool _isProcessing = false;
  bool _showError = false;
  bool _transferCompleted = false;

  void onNumberPressed(String number) {
    if (_isProcessing || _transferCompleted) return;

    setState(() {
      _showError = false;
      if (_enteredPin.length < 4) {
        _enteredPin += number;

        // Auto-submit when PIN is complete
        if (_enteredPin.length == 4) {
          validatePin();
        }
      }
    });
  }

  void onBackspacePressed() {
    if (_isProcessing || _transferCompleted) return;

    setState(() {
      _showError = false;
      if (_enteredPin.isNotEmpty) {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      }
    });
  }

  void validatePin() async {
    if (_enteredPin.length != 4) return;

    setState(() {
      _isProcessing = true;
      _showError = false;
    });

    // Simulate PIN validation API call
    await Future.delayed( Duration(seconds: 2));

    if (mounted && !_transferCompleted) {
      // Mock validation - in real app, this would call your API
      final isValidPin = _enteredPin == '1234'; // Default test PIN

      if (isValidPin) {
        await processTransfer();
      } else {
        setState(() {
          _showError = true;
          _isProcessing = false;
          _enteredPin = '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('Invalid PIN. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> processTransfer() async {
    // Simulate transfer processing
    await Future.delayed( Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _transferCompleted = true;
        _isProcessing = false;
      });

      showTransferSuccessScreen();
    }
  }

  void showTransferSuccessScreen() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return TransferSuccessWidget(
          amount: double.parse(widget.transferData['amount'] ?? '0'),
          recipient: widget.transferData['accountName'] ?? 'Recipient',
          bankName: widget.transferData['bank']?.name ?? 'Bank',
          accountNumber: widget.transferData['accountNumber'] ?? '',
          transactionReference: generateTransactionReference(),
          narration: widget.transferData['narration'] ?? '',
          transactionDate: DateTime.now(),
          onClose: () {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>  HomeScreen()),
                  (route) => false,
            );
          },
          onShareReceipt: () {
            shareReceipt();
          },
          onViewTransaction: () {
            viewTransactionDetails();
          },
          title: 'Transfer Successful',
          subTitle: 'Your transfer has been completed successfully',
          showTransactionDetails: true,
          showActionButtons: true,
        );
      },
    );
  }

  void resetScreen() {
    setState(() {
      _enteredPin = '';
      _isProcessing = false;
      _showError = false;
      _transferCompleted = false;
    });
  }

  void shareReceipt() {
    print('Sharing receipt...');
  }

  void viewTransactionDetails() {
    print('Viewing transaction details...');
  }

  String generateTransactionReference() {
    final now = DateTime.now();
    return 'TF${now.millisecondsSinceEpoch}';
  }

  void clearPin() {
    if (_isProcessing || _transferCompleted) return;

    setState(() {
      _enteredPin = '';
      _showError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: w * 0.07),
          onPressed: (_isProcessing || _transferCompleted) ? null : () => Navigator.pop(context),
        ),
        title: Text(
          _transferCompleted ? 'Transfer Complete' : 'Confirm Transfer',
          style: TextStyle(
            color: Colors.black,
            fontSize: w * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: _transferCompleted ? [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue),
            onPressed: resetScreen,
            tooltip: 'New Transfer',
          ),
        ] : null,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Transfer Summary Card
                if (!_transferCompleted)TransferSummary(width: w, height: h, transferData:widget.transferData,),
                if (_transferCompleted) CompletionMessage(width: w, height: h, transferData: widget.transferData,),

                SizedBox(height: h * 0.04),

                if (!_transferCompleted) ...[
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
                      'Enter your 4-digit PIN to authorize this transfer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: subFont,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],

                SizedBox(height: h * 0.05),

                // PIN dots with error state
                if (!_transferCompleted) ...[
                  Column(
                    children: [
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
                                  ? (_showError ? Colors.red : Colors.blue)
                                  : Colors.grey[300],
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: h * 0.01),
                      if (_showError)
                        Text(
                          'Invalid PIN. Please try again.',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: w * 0.035,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: h * 0.04),
                ],

                // Processing indicator
                if (_isProcessing && !_transferCompleted) ...[
                  Column(
                    children: [
                      SizedBox(
                        width: w * 0.08,
                        height: w * 0.08,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      Text(
                        'Processing Transfer...',
                        style: TextStyle(
                          fontSize: w * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: h * 0.04),
                    ],
                  ),
                ],

                // Completion message
                if (_transferCompleted) ...[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: w * 0.15,
                  ),
                  SizedBox(height: h * 0.02),
                  Text(
                    'Transfer Completed',
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    'You can close this screen or start a new transfer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: w * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: h * 0.04),
                ],

                // Numeric keypad
                if (!_transferCompleted) ...[
                  Opacity(
                    opacity: _isProcessing ? 0.5 : 1.0,
                    child: AbsorbPointer(
                      absorbing: _isProcessing,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NumberButton(
                                  number: '1',
                                  onPressed: onNumberPressed,
                                  size: w * 0.18
                              ),
                              NumberButton(
                                  number: '2',
                                  onPressed: onNumberPressed,
                                  size: w * 0.18
                              ),
                              NumberButton(
                                  number: '3',
                                  onPressed: onNumberPressed,
                                  size: w * 0.18
                              ),
                            ],
                          ),
                          SizedBox(height: keypadSpacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NumberButton(
                                  number: '4',
                                  onPressed: onNumberPressed,
                                  size: w * 0.18
                              ),
                              NumberButton(
                                  number: '5',
                                  onPressed: onNumberPressed,
                                  size: w * 0.18
                              ),
                              NumberButton(
                                  number: '6',
                                  onPressed: onNumberPressed,
                                  size: w * 0.18
                              ),
                            ],
                          ),
                          SizedBox(height: keypadSpacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NumberButton(
                                  number: '7',
                                  onPressed: onNumberPressed,
                                  size: w * 0.18
                              ),
                              NumberButton(
                                  number: '8',
                                  onPressed: onNumberPressed,
                                  size: w * 0.18
                              ),
                              NumberButton(
                                  number: '9',
                                  onPressed: onNumberPressed,
                                  size: w * 0.18
                              ),
                            ],
                          ),
                          SizedBox(height: keypadSpacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: w * 0.18,
                                height: w * 0.18,
                                child: IconButton(
                                  onPressed: clearPin,
                                  icon: Icon(
                                    Icons.clear,
                                    size: w * 0.06,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              NumberButton(
                                  number: '0',
                                  onPressed: onNumberPressed,
                                  size: w * 0.18
                              ),
                              BackspaceButton(
                                onPressed: onBackspacePressed,
                                size: w * 0.18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Forgot PIN option
                if (!_transferCompleted) ...[
                  SizedBox(height: h * 0.04),
                  TextButton(
                    onPressed: _isProcessing ? null : () {
                      showForgotPinDialog();
                    },
                    child: Text(
                      'Forgot PIN?',
                      style: TextStyle(
                        fontSize: w * 0.04,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],

                // New transfer button
                if (_transferCompleted) ...[
                  SizedBox(height: h * 0.02),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: resetScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: h * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'New Transfer',
                        style: TextStyle(
                          fontSize: w * 0.04,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showForgotPinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (context) {
        final w = MediaQuery.of(context).size.width;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(w * 0.06),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // top icon
                CircleAvatar(
                  radius: w * 0.12,
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: w * 0.15,
                    color: Colors.orange,
                  ),
                ),
                 SizedBox(height: 20),
                 Text(
                  'Forgot Transaction PIN?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                 SizedBox(height: 12),
                 Text(
                  'No worries! Please contact our support team to reset your transaction PIN.',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                 SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel button
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding:
                         EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child:  Text('Cancel'),
                    ),
                    // Contact Support button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                         EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:  Text(
                        'Contact Support',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}