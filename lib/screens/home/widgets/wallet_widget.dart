import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/home_provider.dart';
import '../../../provider/login_provider.dart';

class WalletBalanceCard extends StatefulWidget {
  final String? accountNumber;

  const WalletBalanceCard({super.key, this.accountNumber});

  @override
  State<WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends State<WalletBalanceCard> {
  bool _obscureBalance = true;
  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();
    // Fetch wallet balance when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWalletBalance();
    });
  }

  void _fetchWalletBalance() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final accountNumber = widget.accountNumber;

    if (accountNumber != null && accountNumber.isNotEmpty) {
      homeProvider.fetchWalletBalance(accountNumber).then((_) {
        if (_initialLoad) {
          setState(() {
            _initialLoad = false;
          });
        }
      });
    }
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _obscureBalance = !_obscureBalance;
    });
  }

  String _getDisplayBalance(double totalBalance) {
    if (_obscureBalance) {
      return '••••••';
    }
    final actualBalance = totalBalance / 100;
    return '₦${actualBalance.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: true);
    final loginProvider = Provider.of<LoginProvider>(context);
    final totalBalance = homeProvider.totalBalance;
    final user = loginProvider.currentUser;

    return Card(
      color: Colors.blue,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            //  User Initials or Logo
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Text(
                user?.initials ?? 'U',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 🟦 Wallet and Name Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  const Text(
                    'Wallet Balance',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),


                    Text(
                      _getDisplayBalance(totalBalance),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Toggle visibility button
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              icon: Icon(
                _obscureBalance ? Icons.visibility_off : Icons.visibility,
                color: Colors.blue,
              ),
              onPressed: _toggleBalanceVisibility,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}