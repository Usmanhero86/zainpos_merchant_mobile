import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/banks/bank_selection_screen.dart';
import 'package:zainpos_merchant_mobile/screens/pin/pin_entry.dart';
import '../../services/api/api_service.dart';
import '../../services/models/response_model/bank_list_model.dart';

class TransferScreen extends StatefulWidget {
 const TransferScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    _accountNumberController.addListener(_validateAccountNumber);
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _amountController.dispose();
    _narrationController.dispose();
    super.dispose();
  }

  void _validateAccountNumber() {
    final accountNumber = _accountNumberController.text.trim();
    if (accountNumber.length == 10 && _selectedBank != null) {
      _performAccountValidation(accountNumber);
    } else {
      setState(() => _accountName = null);
    }
  }

  void _performAccountValidation(String accountNumber) async {
    setState(() {
      _validatingAccount = true;
    });

    try {
      final name = await ApiService().resolveAccountName(
        bankCode: _selectedBank!.code,
        accountNumber: accountNumber,
      );

      if (!mounted) return;
      setState(() {
        _validatingAccount = false;
        _accountName = name;        // null if not found
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _validatingAccount = false;
        _accountName = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account validation failed: $e')),
      );
    }
  }

  Future<void> _selectBank() async {
    final selectedBank = await Navigator.push<Bank>(
      context,
      MaterialPageRoute(builder: (_) =>  BankSelectionScreen()),
    );
    if (selectedBank != null && mounted) {
      setState(() {
        _selectedBank = selectedBank;
        _accountName = null;
      });
      if (_accountNumberController.text.length == 10) _validateAccountNumber();
    }
  }

  void _proceedToPinEntry() {
    if (_formKey.currentState!.validate()) {
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
    }
  }

  String? _validateAccountNumberField(String? v) {
    if (v == null || v.isEmpty) return 'Please enter account number';
    if (v.length != 10) return 'Account number must be 10 digits';
    if (!RegExp(r'^[0-9]+$').hasMatch(v)) return 'Account number must contain only digits';
    return null;
  }

  String? _validateAmountField(String? v) {
    if (v == null || v.isEmpty) return 'Please enter amount';
    final amt = double.tryParse(v);
    if (amt == null) return 'Please enter a valid amount';
    if (amt <= 0) return 'Amount must be greater than 0';
    if (amt > 1000000) return 'Amount cannot exceed ₦1,000,000';
    return null;
  }

  String? _validateBankSelection() =>
      _selectedBank == null ? 'Please select a bank' : null;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text('Transfer'),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, raints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: raints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding:  EdgeInsets.all(16),
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
                              padding:  EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Select Bank',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                         SizedBox(height: 4),
                                        Text(
                                          _selectedBank?.name ??
                                              'Tap to select bank',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _selectedBank == null
                                                ? Colors.grey
                                                : Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down,
                                      color: Colors.grey.shade600),
                                ],
                              ),
                            ),
                          ),
                          if (_validateBankSelection() != null) ...[
                             SizedBox(height: 4),
                            Text(
                              _validateBankSelection()!,
                              style:  TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ],
                           SizedBox(height: 16),

                          // ---- Account Number ----
                          TextFormField(
                            controller: _accountNumberController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: InputDecoration(
                              labelText: 'Account Number',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              counterText: '',
                              suffixIcon: _validatingAccount
                                  ?  SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                                  : null,
                            ),
                            validator: _validateAccountNumberField,
                          ),
                           SizedBox(height: 8),

                          // ---- Account Name ----
                          if (_accountName != null) ...[
                            Container(
                              width: double.infinity,
                              padding:  EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                border: Border.all(color: Colors.green.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Colors.green.shade600, size: 16),
                                   SizedBox(width: 8),
                                  Text(
                                    'Account Name: $_accountName',
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                             SizedBox(height: 8),
                          ],

                          // ---- Amount ----
                          TextFormField(
                            controller: _amountController,
                            keyboardType:
                             TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              prefixText: '₦ ',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            validator: _validateAmountField,
                          ),
                           SizedBox(height: 16),

                          // ---- Narration ----
                          TextFormField(
                            controller: _narrationController,
                            maxLength: 50,
                            decoration: InputDecoration(
                              labelText: 'Enter narration (optional)',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),

                           Spacer(),

                          // ---- Send Button ----
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  Color(0xFF0066FF),
                                padding:  EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: _proceedToPinEntry,
                              child:  Text(
                                'Send',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
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
