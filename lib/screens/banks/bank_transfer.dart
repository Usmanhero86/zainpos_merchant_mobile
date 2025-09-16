import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/banks/widget/bank_list_item.dart';

class BankSelectionScreen extends StatefulWidget {
  const BankSelectionScreen({super.key});

  @override
  State<BankSelectionScreen> createState() => _BankSelectionScreenState();
}

class _BankSelectionScreenState extends State<BankSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Bank> filteredBanks;

  final List<Bank> _allBanks = [
    Bank(name: 'Access bank', successRate: 95),
    Bank(name: 'Diamond bank', successRate: 72),
    Bank(name: 'Fidelity bank', successRate: 85),
    Bank(name: 'First bank of Nigeria', successRate: 97),
    Bank(name: 'Guaranty Trust bank', successRate: 75),
    Bank(name: 'Jaiz bank', successRate: 90),
    Bank(name: 'Keystone bank', successRate: 70),
    Bank(name: 'Kuda bank', successRate: 80),
    Bank(name: 'Ecobank of Nigeria', successRate: 93),
  ];

  @override
  void initState() {
    super.initState();
    filteredBanks = _allBanks;
    _searchController.addListener(_filterBanks);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_filterBanks)
      ..dispose();
    super.dispose();
  }

  void _filterBanks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredBanks = _allBanks
          .where((b) => b.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    final double headingFont = w * 0.045;
    final double bankNameFont = w * 0.04;
    final double ringSize = w * 0.12;
    final double padding = w * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: w * 0.07, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Back to Network',
          style: TextStyle(
            color: Colors.black38,
            fontSize: w * 0.045,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bank Transfer',
                style: TextStyle(
                  fontSize: headingFont,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: padding),
              itemCount: filteredBanks.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final bank = filteredBanks[index];
                return BankListItem(
                  bank: bank,
                  ringSize: ringSize,
                  fontSize: bankNameFont,
                  spacing: w * 0.03,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Bank {
  final String name;
  final int successRate;
  const Bank({required this.name, required this.successRate});
}
