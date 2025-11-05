import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/provider/home_provider.dart';
import 'package:zainpos_merchant_mobile/provider/login_provider.dart';
import 'package:zainpos_merchant_mobile/screens/network/network_screen.dart';
import 'package:zainpos_merchant_mobile/screens/notifications/notifications_screen.dart';
import '../widgets/home_body.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String? _accountNumber;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  void _loadHomeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.fetchHomeData().then((_) {
        _extractAccountNumber(homeProvider);
      });
    });
  }

  void _extractAccountNumber(HomeProvider homeProvider) {
    if (homeProvider.homeData != null &&
        homeProvider.homeData!.terminals.isNotEmpty) {
      final activeTerminal = homeProvider.homeData!.terminals.firstWhere(
        (terminal) => terminal.isActive,
        orElse: () => homeProvider.homeData!.terminals.first,
      );

      if (mounted) {
        setState(() {
          _accountNumber = activeTerminal.virtualAccountNumber;
        });

        // Fetch wallet balance with the account number
        if (_accountNumber != null && _accountNumber!.isNotEmpty) {
          homeProvider.fetchWalletBalance(_accountNumber!);
        }
      }
    }
  }

  Future<void> _refreshData() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await homeProvider.refreshData();
    _extractAccountNumber(homeProvider);
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.04;

    // Get user's first name or fallback
    final businessName =
        loginProvider.currentUser?.fullName.split(' ').first ?? 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, $businessName',
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.055,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.blue, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Image(
              height: 24,
              width: 24,
              image: const AssetImage('assets/logos/serviceIcon.png'),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NetworkSelectionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: HomeBody(
          homeProvider: homeProvider,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          padding: padding,
          accountNumber: _accountNumber,
        ),
      ),
    );
  }
}
