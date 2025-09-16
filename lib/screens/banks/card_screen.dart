import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/banks/widget/bank_row.dart';
import 'model/bank_model.dart';


class CardPaymentScreen extends StatefulWidget {
  const CardPaymentScreen({super.key});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final List<BankSuccessRate> _successRates = [
    BankSuccessRate(bank: 'Access bank', mcard: 97, verve: 94, visa: 95),
    BankSuccessRate(bank: 'Diamond bank', mcard: 97, verve: 97, visa: 97),
    BankSuccessRate(bank: 'Fidelity bank', mcard: 97, verve: 97, visa: 97),
    BankSuccessRate(bank: 'First bank of \n Nigeria', mcard: 97, verve: 50, visa: 97),
    BankSuccessRate(bank: 'Guaranty Trust Bank', mcard: 0, verve: 97, visa: 97),
    BankSuccessRate(bank: 'Jaiz bank', mcard: 97, verve: 97, visa: 97),
    BankSuccessRate(bank: 'Keystone bank', mcard: 84, verve: 97, visa: 97),
    BankSuccessRate(bank: 'Kuda bank', mcard: 97, verve: 97, visa: 97),
    BankSuccessRate(bank: 'Ecobank of Nigeria', mcard: 97, verve: 97, visa: 97),
    BankSuccessRate(bank: 'First City \n Monument Bank', mcard: 20, verve: 17, visa: 32),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Back to Network', style: TextStyle(
            color: Colors.black38
        ),),
        actions: [
          IconButton(onPressed: (){},
              icon: Image(image: AssetImage("assets/logos/searchIcon.png"),
                height: 24, width: 24,))
        ],
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Card Payment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(' ',)),
                Expanded(
                  child: Text(
                    'Mcard',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Verve',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Visa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Table Content
          Expanded(
            child: ListView.separated(
              itemCount: _successRates.length,
              itemBuilder: (context, index) {
                final rate = _successRates[index];
                return BankRow(rate: rate);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}

