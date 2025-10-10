import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/provider/home_provider.dart';
import 'package:zainpos_merchant_mobile/provider/login_provider.dart'; // Add this import
import 'package:zainpos_merchant_mobile/screens/network/network_screen.dart';
import 'package:zainpos_merchant_mobile/screens/notifications/notifications_screen.dart';
import '../widgets/home_content_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_widget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  void _loadHomeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.fetchHomeData();
    });
  }

  void _refreshData() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.04;

    // final String currentDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    // Get user's first name or fallback
    final businessName = loginProvider.currentUser?.fullName.split(' ').first ?? 'User';

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
            // Text(
            //   currentDate,
            //   style: TextStyle(
            //       color: Colors.black54,
            //       fontSize: screenWidth * 0.032,
            //       fontWeight: FontWeight.w400
            //   ),
            // ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications, color: Colors.blue, size: 24),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const NotificationsScreen()));
            },
          ),
          IconButton(icon: Image(height: 24, width: 24, image: const AssetImage('assets/logos/serviceIcon.png'),),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const NetworkSelectionScreen()));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
        },
        child: buildBody(homeProvider, screenWidth, screenHeight, padding),
      ),
    );
  }

  Widget buildBody(HomeProvider homeProvider, double screenWidth, double screenHeight, double padding) {
    if (homeProvider.isLoading && homeProvider.homeData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (homeProvider.errorMessage.isNotEmpty && homeProvider.homeData == null) {
      return ErrorState(
        homeProvider: homeProvider,
        screenWidth: screenWidth,
        padding: padding,
        onRetry: _refreshData,
      );
    }

    if (homeProvider.homeData == null) {
      return EmptyState(
        onAction: _refreshData,
        actionText: 'Load Data',
      );
    }

    return HomeContent(
      homeProvider: homeProvider,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      padding: padding,
    );
  }
}