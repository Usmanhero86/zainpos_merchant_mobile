import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/screens/home/home_screen.dart';
import 'package:zainpos_merchant_mobile/screens/pin/change_pin_screen.dart';
import 'package:zainpos_merchant_mobile/services/api/api_service.dart';
import 'package:zainpos_merchant_mobile/widgets/transfer_success_widget.dart';
import '../../provider/pin_provider.dart';
import '../../services/models/response_model/transfer_response_model.dart';
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
  TransferResponse? _transferResponse;

  // Build mode detection
  bool get isDebugMode {
    bool isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());
    return isDebug;
  }

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

    // Clear any existing states (especially important in release mode)
    if (!isDebugMode) {
      ScaffoldMessenger.of(context).clearSnackBars();
    }

    setState(() {
      _isProcessing = true;
      _showError = false;
    });

    try {
      await processRealTransfer();
    } catch (e) {
      if (mounted) {
        setState(() {
          _showError = true;
          _isProcessing = false;
          _enteredPin = '';
        });

        _safeShowSnackBar('PIN validation failed: ${e.toString()}', Colors.red);
      }
    }
  }

  Future<void> processRealTransfer() async {
    try {
      setState(() {
        _isProcessing = true;
      });

      // Get the transfer data
      final bank = widget.transferData['bank'];
      final accountNumber = widget.transferData['accountNumber'] ?? '';
      final accountName = widget.transferData['accountName'] ?? '';
      final amount = widget.transferData['amount'] ?? '0';
      final narration = widget.transferData['narration'] ?? '';
      final sourceAccountNumber = widget.transferData['sourceAccountNumber'] ?? '';
      final zainboxCode = widget.transferData['zainboxCode'] ?? '';
      final terminalId = widget.transferData['terminalId'] ?? '';

      debugPrint('=== REAL TRANSFER INITIATION ===');
      debugPrint('Destination: $accountNumber ($accountName)');
      debugPrint('Bank: ${bank.name} (${bank.code})');
      debugPrint('Amount: $amount');
      debugPrint('Narration: $narration');
      debugPrint('Source Account: $sourceAccountNumber');
      debugPrint('Zainbox Code: $zainboxCode');
      debugPrint('Terminal ID: $terminalId');
      debugPrint('PIN Length: ${_enteredPin.length}');

      // Validate required fields
      if (sourceAccountNumber.isEmpty) {
        throw Exception('Source account number is required');
      }
      if (zainboxCode.isEmpty) {
        throw Exception('Zainbox code is required');
      }
      if (terminalId.isEmpty) {
        throw Exception('Terminal ID is required');
      }

      // Call the real API with the entered PIN
      final response = await ApiService().initiateFundTransfer(
        destinationAccountNumber: accountNumber,
        destinationAccountName: accountName,
        destinationBankCode: bank.code,
        destinationBankName: bank.name,
        amount: amount,
        sourceAccountNumber: sourceAccountNumber,
        zainboxCode: zainboxCode,
        narration: narration,
        terminalId: terminalId,
        pin: _enteredPin,
      );

      if (!mounted) return;

      debugPrint('=== TRANSFER RESPONSE ANALYSIS ===');
      debugPrint('Response isSuccess: ${response.isSuccess}');
      debugPrint('Response success: ${response.success}');
      debugPrint('Response error: ${response.error}');
      debugPrint('Response hasError: ${response.hasError}');
      debugPrint('Response message: ${response.message}');
      debugPrint('Response displayMessage: ${response.displayMessage}');
      debugPrint('Is Insufficient Funds: ${response.isInsufficientFunds}');
      debugPrint('Is Invalid PIN: ${response.isInvalidPin}');

      // ROBUST SUCCESS CONDITION - Check multiple indicators
      final bool isSuccessful = response.isSuccess &&
          response.success &&
          !response.error &&
          !response.hasError;

      debugPrint('Final success determination: $isSuccessful');

      // Use a small delay to ensure state is properly updated
      await Future.delayed(Duration(milliseconds: 100));

      if (!mounted) return;

      setState(() {
        _transferResponse = response;
        _isProcessing = false;
      });

      // USE THE ROBUST SUCCESS CONDITION
      if (isSuccessful) {
        debugPrint('=== TRANSFER SUCCESSFUL - SHOWING SUCCESS SCREEN ===');

        // Add another small delay before showing success screen
        await Future.delayed(Duration(milliseconds: 50));

        if (!mounted) return;

        setState(() {
          _transferCompleted = true;
        });

        _showTransferSuccessScreen();
      } else {
        debugPrint('=== TRANSFER FAILED - SHOWING ERROR ===');

        // Clear any existing snackbars first
        ScaffoldMessenger.of(context).clearSnackBars();

        // Add delay before showing error
        await Future.delayed(Duration(milliseconds: 50));

        if (!mounted) return;

        setState(() {
          _isProcessing = false;
          _enteredPin = '';
        });

        // Handle specific error types
        if (response.isInvalidPin) {
          setState(() {
            _showError = true;
          });
        }

        // Show error snackbar using safe method
        _safeShowSnackBar(
          response.displayMessage,
          response.isInsufficientFunds ? Colors.orange : Colors.red,
        );
      }

    } catch (e) {
      if (!mounted) return;

      debugPrint('=== TRANSFER ERROR ===');
      debugPrint('Exception: $e');

      // Clear existing snackbars
      ScaffoldMessenger.of(context).clearSnackBars();

      // Add delay before showing error
      await Future.delayed(Duration(milliseconds: 50));

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _showError = true;
        _enteredPin = '';
      });

      _safeShowSnackBar(
        'Transfer failed: ${e.toString().replaceAll('Exception: ', '')}',
        Colors.red,
      );
    }
  }

  // Safe method to show snackbar without conflicts
  void _safeShowSnackBar(String message, Color backgroundColor) {
    // Clear any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    // Small delay to ensure UI is ready (especially in release mode)
    Future.delayed(Duration(milliseconds: isDebugMode ? 50 : 100), () {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 5),
        ),
      );
    });
  }

  void _showTransferSuccessScreen() {
    debugPrint('=== SHOWING SUCCESS SCREEN ===');

    // Clear any existing snackbars first (critical for release mode)
    ScaffoldMessenger.of(context).clearSnackBars();

    if (!mounted) {
      debugPrint('=== CONTEXT NOT MOUNTED - CANNOT SHOW SUCCESS SCREEN ===');
      return;
    }

    // Use a longer delay to ensure everything is settled (especially in release mode)
    Future.delayed(Duration(milliseconds: isDebugMode ? 100 : 200), () {
      if (!mounted) return;

      try {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext context) {
            debugPrint('=== BUILDING SUCCESS WIDGET ===');

            // Extract data with null checks
            final bank = widget.transferData['bank'];

            // Use the amount from transfer data (it's in kobo, so divide by 100)
            final originalAmount = double.tryParse(widget.transferData['amount']?.toString() ?? '0') ?? 0;
            final amountInNaira = originalAmount / 100; // Convert from kobo to naira

            final accountName = widget.transferData['accountName']?.toString() ?? 'Recipient';
            final accountNumber = widget.transferData['accountNumber']?.toString() ?? '';
            final narration = widget.transferData['narration']?.toString() ?? '';

            debugPrint('Amount details:');
            debugPrint('  Original amount: $originalAmount');
            debugPrint('  Amount in Naira: $amountInNaira');

            return TransferSuccessWidget(
              amount: amountInNaira, // Use the converted amount
              recipient: accountName,
              bankName: bank?.name?.toString() ?? 'Bank',
              accountNumber: accountNumber,
              transactionReference: _transferResponse?.reference ?? generateTransactionReference(),
              narration: narration,
              transactionDate: DateTime.now(),
              onClose: () {
                debugPrint('=== CLOSING SUCCESS SCREEN ===');
                // Navigate back to home
                Navigator.of(context).pop(); // Close success screen
                Navigator.of(context).pop(); // Close PIN screen
              },
              onShareReceipt: () {
                debugPrint('=== SHARE RECEIPT ===');
                // Add your share functionality here
              },
              onViewTransaction: () {
                debugPrint('=== VIEW TRANSACTION DETAILS ===');
                // Add your view transaction functionality here
              },
              title: 'Transfer Successful!',
              subTitle: 'You have successfully transferred\n₦${amountInNaira.toStringAsFixed(2)} to $accountName',
              showTransactionDetails: true,
              showActionButtons: true,
            );
          },
        ).then((value) {
          debugPrint('=== SUCCESS SCREEN CLOSED ===');
        }).catchError((error) {
          debugPrint('=== ERROR SHOWING SUCCESS SCREEN: $error ===');
          // Fallback to dialog
          _showFallbackSuccessDialog();
        });
      } catch (e) {
        debugPrint('=== ERROR SHOWING SUCCESS SCREEN: $e ===');
        _showFallbackSuccessDialog();
      }
    });
  }

  void _showFallbackSuccessDialog() {
    if (!mounted) return;

    // Clear any existing snackbars before showing dialog
    ScaffoldMessenger.of(context).clearSnackBars();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Transfer Successful'),
        content: Text('Your transfer was completed successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close PIN screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void resetScreen() {
    if (!mounted) return;

    // Clear all snackbars first
    ScaffoldMessenger.of(context).clearSnackBars();

    // Reset all states
    setState(() {
      _enteredPin = '';
      _isProcessing = false;
      _showError = false;
      _transferCompleted = false;
      _transferResponse = null;
    });
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
    final double dotSize = w * 0.12;
    final double dotSpacing = w * 0.02;
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
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_transferCompleted) ...[
                  Text(
                    'Enter your PIN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    'Enter your PIN to complete this transaction',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],

                SizedBox(height: h * 0.05),

                // PIN dots
                if (!_transferCompleted) ...[
                  Column(
                    children: [
                      Container(
                        height: 50,
                        padding: EdgeInsets.all(w * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _showError ? Colors.red : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: dotSpacing),
                              decoration: BoxDecoration(
                                color: index < _enteredPin.length
                                    ? (_showError ? Colors.red : Colors.white70)
                                    : Colors.grey[100],
                              ),
                              child: index < _enteredPin.length
                                  ? Icon(
                                Icons.star,
                                size: dotSize * 0.4,
                                color: Colors.black,
                              )
                                  : null,
                            );
                          }),
                        ),
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
                        child: const CircularProgressIndicator(
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

                if (!_transferCompleted && !_isProcessing) ...[
                  Opacity(
                    opacity: _isProcessing ? 0.5 : 1.0,
                    child: AbsorbPointer(
                      absorbing: _isProcessing,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NumberButton(number: '1', onPressed: onNumberPressed, size: w * 0.18),
                              NumberButton(number: '2', onPressed: onNumberPressed, size: w * 0.18),
                              NumberButton(number: '3', onPressed: onNumberPressed, size: w * 0.18),
                            ],
                          ),
                          SizedBox(height: keypadSpacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NumberButton(number: '4', onPressed: onNumberPressed, size: w * 0.18),
                              NumberButton(number: '5', onPressed: onNumberPressed, size: w * 0.18),
                              NumberButton(number: '6', onPressed: onNumberPressed, size: w * 0.18),
                            ],
                          ),
                          SizedBox(height: keypadSpacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NumberButton(number: '7', onPressed: onNumberPressed, size: w * 0.18),
                              NumberButton(number: '8', onPressed: onNumberPressed, size: w * 0.18),
                              NumberButton(number: '9', onPressed: onNumberPressed, size: w * 0.18),
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
                              NumberButton(number: '0', onPressed: onNumberPressed, size: w * 0.18),
                              BackspaceButton(onPressed: onBackspacePressed, size: w * 0.18),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Forgot PIN option
                  if (!_transferCompleted) ...[
                    SizedBox(height: h * 0.04),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=> ChangePinScreen()));
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

                  // Retry button for failed transfers
                  if (_transferResponse?.hasError == true) ...[
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
                          'Try Again',
                          style: TextStyle(
                            fontSize: w * 0.04,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: w * 0.04,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}