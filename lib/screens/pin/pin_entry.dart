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

  // Mock PIN configuration
  final bool _useMockPin = false;

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

    try {
      final pinProvider = Provider.of<PinProvider>(context, listen: false);

      if (pinProvider.useMockPin) {
        await processMockTransfer(pinProvider);
      } else {
        await processRealTransfer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _showError = true;
          _isProcessing = false;
          _enteredPin = '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PIN validation failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> processMockTransfer(PinProvider pinProvider) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Use dynamic mock PIN from provider
    if (pinProvider.validateMockPin(_enteredPin)) {
      // Successful transfer
      setState(() {
        _transferCompleted = true;
        _isProcessing = false;
      });

      // Create mock successful response
      _transferResponse = TransferResponse(
        isSuccess: true,
        message: 'Transfer successful (Mock)',
        reference: generateTransactionReference(),
        error: false,
      );

      showTransferSuccessScreen();
    } else {
      // Failed transfer - wrong PIN
      setState(() {
        _showError = true;
        _isProcessing = false;
        _enteredPin = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid PIN. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
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

      debugPrint('=== REAL TRANSFER INITIATION ===');
      debugPrint('Destination: $accountNumber ($accountName)');
      debugPrint('Bank: ${bank.name} (${bank.code})');
      debugPrint('Amount: $amount');
      debugPrint('Narration: $narration');

      // Call the real API with the entered PIN
      final response = await ApiService().initiateFundTransfer(
        destinationAccountNumber: accountNumber,
        destinationAccountName: accountName,
        destinationBankCode: bank.code,
        destinationBankName: bank.name,
        amount: amount,
        sourceAccountNumber: '4423190554', // TODO: Make this dynamic
        zainboxCode: '34447_hAkmg9YimuL28OgTdtEr', // TODO: Make this dynamic
        narration: narration,
        terminalId: '2070GPQ21', // TODO: Make this dynamic
        pin: _enteredPin,
      );

      if (!mounted) return;

      setState(() {
        _transferResponse = response;
        _transferCompleted = true;
        _isProcessing = false;
      });

      if (response.isSuccess && response.Success) {
        debugPrint('=== TRANSFER SUCCESSFUL ===');
        debugPrint('Reference: ${response.reference}');
        debugPrint('Message: ${response.message}');

        showTransferSuccessScreen();
      } else {
        // Handle specific error types
        debugPrint('=== TRANSFER FAILED ===');
        debugPrint('Error Type: ${response.errorType}');
        debugPrint('Message: ${response.message}');
        debugPrint('Code: ${response.code}');

        if (response.isInvalidPin) {
          // Specific handling for invalid PIN
          setState(() {
            _showError = true;
            _isProcessing = false;
            _enteredPin = ''; // Clear PIN for security
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid PIN. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        } else if (response.isInsufficientFunds) {
          // Handle insufficient funds
          setState(() {
            _isProcessing = false;
            _enteredPin = '';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.displayMessage),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
            ),
          );
        } else {
          // General error handling
          setState(() {
            _isProcessing = false;
            _enteredPin = '';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.displayMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }

    } catch (e) {
      if (!mounted) return;

      debugPrint('=== TRANSFER ERROR ===');
      debugPrint('Exception: $e');

      setState(() {
        _isProcessing = false;
        _showError = true;
        _enteredPin = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transfer failed: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> processTransfer() async {
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

      // Call the real API
      final response = await ApiService().initiateFundTransfer(
        destinationAccountNumber: accountNumber,
        destinationAccountName: accountName,
        destinationBankCode: bank.code,
        destinationBankName: bank.name,
        amount: amount,
        sourceAccountNumber: '4423190554', // You need to get this from your app state
        zainboxCode: '34447_hAkmg9YimuL28OgTdtEr', // You need to get this from your app state
        narration: narration,
        terminalId: '2070GPQ21', // You need to get this from your terminal selection
        pin: _enteredPin,
      );

      if (!mounted) return;

      setState(() {
        _transferResponse = response;
        _transferCompleted = true;
        _isProcessing = false;
      });

      if (response.Success) {
        showTransferSuccessScreen();
      } else {
        // Show error from API response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.displayMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );

        // Reset PIN for security
        setState(() {
          _enteredPin = '';
          _isProcessing = false;
        });
      }

    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _showError = true;
        _enteredPin = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transfer failed: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
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
          transactionReference: _transferResponse?.reference ?? generateTransactionReference(),
          narration: widget.transferData['narration'] ?? '',
          transactionDate: DateTime.now(),
          onClose: () {
            Navigator.pop(context); // Close success screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
            );
          },
          title: 'Transfer Successful',
          subTitle: 'You have successfully sent \n${widget.transferData['amount']} to ${widget.transferData['accountName']}',
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
                    _useMockPin ? 'Enter Mock PIN' : 'Enter your PIN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),                  SizedBox(height: h * 0.01),
                  Text(
                    'Enter your PIN to complete this transaction',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  if (_useMockPin) ...[
                    SizedBox(height: h * 0.01),
                  ],
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
                        _useMockPin ? 'Processing Mock Transfer...' : 'Processing Transfer...',
                        style: TextStyle(
                          fontSize: w * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: h * 0.04),
                    ],
                  ),
                ],

                if (!_transferCompleted ) ...[
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
                              ),                              NumberButton(number: '0', onPressed: onNumberPressed, size: w * 0.18),
                              BackspaceButton(onPressed: onBackspacePressed, size: w * 0.18),                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Forgot PIN option
                  if (!_transferCompleted ) ...[
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