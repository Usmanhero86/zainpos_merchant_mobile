import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/home_provider.dart';

class WalletBalanceCard extends StatefulWidget {
  const WalletBalanceCard({super.key});

  @override
  State<WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends State<WalletBalanceCard> {
  bool _obscureBalance = true;

  void _toggleBalanceVisibility() {
    setState(() {
      _obscureBalance = !_obscureBalance;
    });
  }

  String _getDisplayBalance(double totalBalance) {
    if (_obscureBalance) {
      return '••••••';
    }
    // Divide by 100 and format to 2 decimal places
    final actualBalance = totalBalance / 100;
    return 'N${actualBalance.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final totalBalance = homeProvider.totalBalance;

    return Card(
      color: Colors.blue,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Image(
              image: const AssetImage('assets/logos/FeaturedIcon5.png'),
              height: 38,
              width: 38,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet Balance',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    _getDisplayBalance(totalBalance),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                iconSize: 30),
              icon: Icon(
                _obscureBalance
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.blue,
              ),
              onPressed: _toggleBalanceVisibility,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize:20,
            ),
          ],
        ),
      ),
    );
  }
}