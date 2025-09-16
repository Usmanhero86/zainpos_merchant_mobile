import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/pin/pin_entry.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedBank;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Transfer'),
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bank Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Bank',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                value: selectedBank,
                items: const [
                  DropdownMenuItem(
                      value: 'Wema Bank', child: Text('Wema Bank')),
                  DropdownMenuItem(
                      value: 'Access Bank', child: Text('Access Bank')),
                  DropdownMenuItem(
                      value: 'GTBank', child: Text('GTBank')),
                ],
                onChanged: (value) => setState(() => selectedBank = value),
                // validator: (value) =>
                // value == null ? 'Please select a bank' : null,
              ),
               SizedBox(height: 16),

              // Account Number
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // validator: (value) =>
                // value!.isEmpty ? 'Enter account number' : null,
              ),
               SizedBox(height: 16),

              // Amount
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // validator: (value) =>
                // value!.isEmpty ? 'Enter amount' : null,
              ),
               SizedBox(height: 16),

              // Narration
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter narration',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
               SizedBox(height: 32),

              // Send Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0066FF),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // if (_formKey.currentState!.validate()) {
                    //   // Trigger transfer action
                    // }
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=> PinEntryScreen()));
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
