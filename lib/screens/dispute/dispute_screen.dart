import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/dispute/model/dispute_model.dart';
import 'package:zainpos_merchant_mobile/screens/dispute/widgets/dispute_item.dart';

class DisputeScreen extends StatefulWidget {
  const DisputeScreen({super.key});

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  final List<DisputeModel> transactions = [
    DisputeModel(
      status: 'TRN',
      terminal: 'ZNPOS269528555',
      amount: 22500.00,
      date: '2024-02-18',
      reference: '269528555',
      resolved: 'RESOLVED',
    ),
    DisputeModel(
      status: 'TRN',
      terminal: 'ZNPOS269528555',
      amount: 22500.00,
      date: '2024-02-18',
      reference: '269528555',
      resolved: 'RESOLVED',
    ),
    DisputeModel(
      status: 'TRN',
      terminal: 'ZNPOS269528555',
      amount: 22500.00,
      date: '2024-02-18',
      reference: '269528555',
      resolved: 'RESOLVED',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    final double titleFont = w * 0.05;
    final double iconSize = w * 0.06;
    final double dividerThickness = w * 0.002;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          'Dispute',
          style: TextStyle(
            fontSize: titleFont,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/logos/searchIcon.png',
              height: iconSize,
              width: iconSize,
            ),
            onPressed: () {
              // search action
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey[200],
          thickness: dividerThickness,
          height: h * 0.01,
        ),
        itemBuilder: (context, index) {
          return DisputeItem(transaction: transactions[index]);
        },
      ),
    );
  }
}
