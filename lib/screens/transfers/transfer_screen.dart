import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/banks/empty_bank_selection.dart';
import 'package:zainpos_merchant_mobile/screens/pin/pin_entry.dart';
import '../../services/api/api_service.dart';
import '../../services/models/response_model/bank_list_model.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key, this.walletBalance});
  final double? walletBalance;

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _narrationController = TextEditingController();

  Bank? _selectedBank;
  String? _accountName;
  bool _validatingAccount = false;
  bool _accountValidated = false;

  @override
  void initState() {
    super.initState();
    _accountNumberController.addListener(_validateAccountNumber);
  }

  @override
  void dispose() {
    _accountNumberController.removeListener(_validateAccountNumber);
    _accountNumberController.dispose();
    _amountController.dispose();
    _narrationController.dispose();
    super.dispose();
  }

  void _validateAccountNumber() {
    final accountNumber = _accountNumberController.text.trim();

    // Reset validation state when account number changes
    if (_accountValidated) {
      setState(() {
        _accountValidated = false;
        _accountName = null;
      });
    }

    // Only validate if we have exactly 10 digits and a selected bank
    if (accountNumber.length == 10 &&
        _selectedBank != null &&
        RegExp(r'^[0-9]+$').hasMatch(accountNumber)) {
      _performAccountValidation(accountNumber);
    } else {
      setState(() {
        _accountName = null;
        _accountValidated = false;
      });
    }
  }

  void _performAccountValidation(String accountNumber) async {
    setState(() {
      _validatingAccount = true;
      _accountName = null;
      _accountValidated = false;
    });

    try {
      final name = await ApiService().resolveAccountEnquiry(
        bankCode: _selectedBank!.code, accountNumber: accountNumber,);

      if (name == null) {
        throw Exception('Account name resolution returned null');
      }

      if (!mounted) return;

      setState(() {
        _validatingAccount = false;
        _accountName = name;
        _accountValidated = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _validatingAccount = false;
        _accountName = null;
        _accountValidated = false;
      });

      String errorMessage = e.toString().replaceAll('Exception: ', '');

      // More specific error messages
      if (errorMessage.contains('not found') ||
          errorMessage.contains('invalid') ||
          errorMessage.contains('failed with code')) {
        errorMessage = 'Account number not found in ${_selectedBank!
            .name}. Please check the account number and try again.';
      } else if (errorMessage.contains('network') ||
          errorMessage.contains('timeout')) {
        errorMessage =
        'Network error. Please check your connection and try again.';
      } else if (errorMessage.contains('Authentication failed')) {
        errorMessage = 'Session expired. Please login again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _selectBank() async {
    final selectedBank = await Navigator.push<Bank>(
      context,
      MaterialPageRoute(builder: (_) => const EmptyBankSelection()),
    );
    if (selectedBank != null && mounted) {
      setState(() {
        _selectedBank = selectedBank;
        _accountName = null;
        _accountValidated = false;
      });
      // Re-validate account number if it exists
      if (_accountNumberController.text.length == 10) {
        _validateAccountNumber();
      }
    }
  }

  void _proceedToPinEntry() {
    if (_formKey.currentState!.validate() && _accountValidated) {
      final transferData = {
        'bank': _selectedBank!,
        'accountNumber': _accountNumberController.text.trim(),
        'amount': _amountController.text.trim(),
        'narration': _narrationController.text.trim(),
        'accountName': _accountName,
      };
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PinEntryScreen(transferData: transferData),
        ),
      );
    } else
    if (!_accountValidated && _accountNumberController.text.length == 10) {
      // Show error if account is not validated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for account validation to complete'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  String? _validateAccountNumberField(String? v) {
    if (v == null || v.isEmpty) return 'Please enter account number';
    if (v.length != 10) return 'Account number must be 10 digits';
    if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
      return 'Account number must contain only digits';
    }
    if (_selectedBank == null) return 'Please select a bank first';
    if (!_accountValidated) return 'Please wait for account validation';
    return null;
  }

  String? _validateBankSelection() {
    if (_selectedBank == null) {
      return 'Please select a bank';
    }
    return null;
  }

  String? _validateAmountField(String? v) {
    if (v == null || v.isEmpty) return 'Please enter amount';
    final amt = double.tryParse(v);
    if (amt == null) return 'Please enter a valid amount';
    if (amt < 10) return 'Amount must be at least ₦10';
    if (widget.walletBalance != null && amt > widget.walletBalance!) {
      return 'Insufficient balance';
    }
    if (amt > 1000000) return 'Amount cannot exceed ₦1,000,000';
    return null;
  }

  void _checkAmountAndShowSnackBar(String amount) {
    final amt = double.tryParse(amount);
    if (amt == null) return;

    if (amt < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Amount must be at least ₦10'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
    else if (widget.walletBalance != null && amt > widget.walletBalance!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Insufficient balance. Available: ₦${widget.walletBalance!
                  .toStringAsFixed(2)}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

    @override
    Widget build(BuildContext context) {
      final screenWidth = MediaQuery
          .of(context)
          .size
          .width;
      final bottomInset = MediaQuery
          .of(context)
          .viewInsets
          .bottom;
      final isTablet = screenWidth > 600;

      // Responsive sizing
      final basePadding = isTablet ? 24.0 : 16.0;
      final titleSize = isTablet ? 28.0 : 22.0;
      final labelSize = isTablet ? 16.0 : 14.0;
      final inputTextSize = isTablet ? 18.0 : 16.0;
      final buttonHeight = isTablet ? 60.0 : 50.0;
      final iconSize = isTablet ? 24.0 : 20.0;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Back to Terminal',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: isTablet ? 16.0 : 14.0,
              color: Colors.grey,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: iconSize,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.all(basePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            'Transfer',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: isTablet ? 32.0 : 24.0),

                          // Form
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ---- Bank selection ----
                                  InkWell(
                                    onTap: _selectBank,
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: basePadding,
                                        vertical: isTablet ? 20.0 : 16.0,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  _selectedBank?.name ??
                                                      'Select Bank',
                                                  style: TextStyle(
                                                    fontSize: inputTextSize,
                                                    color: _selectedBank == null
                                                        ? Colors.grey
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                if (_selectedBank != null)
                                                  Text(
                                                    _selectedBank!.code,
                                                    style: TextStyle(
                                                      fontSize: labelSize - 2,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.grey.shade600,
                                            size: iconSize,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_validateBankSelection() != null) ...[
                                    SizedBox(height: isTablet ? 8.0 : 4.0),
                                    Text(
                                      _validateBankSelection()!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: labelSize,
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: isTablet ? 24.0 : 16.0),

                                  // ---- Account Number ----
                                  TextFormField(
                                    controller: _accountNumberController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    style: TextStyle(fontSize: inputTextSize),
                                    decoration: InputDecoration(
                                      labelText: 'Account Number',
                                      labelStyle: TextStyle(fontSize: labelSize,
                                          color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: basePadding,
                                        vertical: isTablet ? 20.0 : 16.0,
                                      ),
                                      counterText: '',
                                      suffixIcon: _validatingAccount
                                          ? SizedBox(
                                        width: iconSize,
                                        height: iconSize,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                          : _accountValidated
                                          ? Icon(
                                        Icons.verified,
                                        color: Colors.green,
                                        size: iconSize,
                                      )
                                          : null,
                                      hintText: 'Enter 10-digit account number',
                                    ),
                                    validator: _validateAccountNumberField,
                                  ),
                                  SizedBox(height: isTablet ? 16.0 : 8.0),

                                  // ---- Account Name Display ----
                                  if (_accountName != null &&
                                      _accountValidated) ...[
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(basePadding),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        border: Border.all(
                                            color: Colors.green.shade200),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green.shade600,
                                            size: iconSize,
                                          ),
                                          SizedBox(
                                              width: isTablet ? 12.0 : 8.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  'Account Holder Name',
                                                  style: TextStyle(
                                                    fontSize: labelSize,
                                                    color: Colors.grey.shade600,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  _accountName!,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade800,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: inputTextSize,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 16.0 : 8.0),
                                  ],

                                  // ---- Amount ----
                                  TextFormField(
                                    controller: _amountController,
                                    keyboardType: TextInputType
                                        .numberWithOptions(decimal: true),
                                    style: TextStyle(fontSize: inputTextSize),
                                    decoration: InputDecoration(
                                      labelText: 'Amount',
                                      labelStyle: TextStyle(fontSize: labelSize,
                                          color: Colors.grey),
                                      prefixText: '₦ ',
                                      prefixStyle: TextStyle(
                                        fontSize: inputTextSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: basePadding,
                                        vertical: isTablet ? 20.0 : 16.0,
                                      ),
                                      hintText: widget.walletBalance != null
                                          ? 'Available: ₦${widget.walletBalance!
                                          .toStringAsFixed(2)}'
                                          : 'Enter amount',
                                      hintStyle: TextStyle(
                                        fontSize: labelSize - 2,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      // Real-time validation feedback
                                      if (value.isNotEmpty) {
                                        _checkAmountAndShowSnackBar(value);
                                      }
                                    },


                                    validator: _validateAmountField,
                                  ),
                                  SizedBox(height: isTablet ? 24.0 : 16.0),

                                  // ---- Narration ----
                                  TextFormField(
                                    controller: _narrationController,
                                    style: TextStyle(fontSize: inputTextSize),
                                    decoration: InputDecoration(
                                      labelText: 'Enter narration',
                                      labelStyle: TextStyle(fontSize: labelSize,
                                          color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: basePadding,
                                        vertical: isTablet ? 20.0 : 16.0,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 15),

                                  // ---- Send Button ----
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 320,
                                      height: buttonHeight,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _accountValidated
                                              ? const Color(0xFF0066FF)
                                              : Colors.grey.shade400,
                                          padding: EdgeInsets.symmetric(
                                              vertical: isTablet ? 20.0 : 16.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                isTablet ? 16.0 : 50.0),
                                          ),
                                        ),
                                        onPressed: _accountValidated
                                            ? _proceedToPinEntry
                                            : null,
                                        child: Text(
                                          'Send',
                                          style: TextStyle(
                                            fontSize: isTablet ? 18.0 : 16.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }