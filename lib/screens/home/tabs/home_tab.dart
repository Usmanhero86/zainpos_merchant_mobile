import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/provider/home_provider.dart';
import 'package:zainpos_merchant_mobile/screens/network/network_screen.dart';
import 'package:zainpos_merchant_mobile/screens/notifications/notifications_screen.dart';
import 'package:zainpos_merchant_mobile/widgets/build_transaction_card.dart';
import '../../../services/models/response_model/home_response.dart';
import '../widgets/home_content_widget.dart';
import '../widgets/list_widget.dart';
import '../widgets/placeholder_widget.dart';
import '../widgets/today_widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.fetchHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.04;
    final titleFontSize = screenWidth * 0.05;
    final subtitleFontSize = screenWidth * 0.035;

    final String currentDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Gidado',
              style: TextStyle(
                color: Colors.black,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.004),
            Text(
              currentDate,
              style: TextStyle(
                color: Colors.black,
                fontSize: subtitleFontSize,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.blue, size: screenWidth * 0.06),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> NotificationsScreen()));
            },
          ),
          IconButton(
            icon: Image(
              height: 24, width: 24,
              image: AssetImage('assets/logos/serviceIcon.png'),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> NetworkSelectionScreen()));
            },
          ),
        ],
      ),
      body: buildBody(homeProvider, screenWidth, screenHeight, padding),
    );
  }

  Widget buildBody(HomeProvider homeProvider, double screenWidth, double screenHeight, double padding) {
    if (homeProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (homeProvider.errorMessage.isNotEmpty) {
      return errorState(homeProvider, screenWidth, padding);
    }

    if (homeProvider.homeData == null) {
      return EmptyState();
    }

    return homeContent(homeProvider, screenWidth, screenHeight, padding);
  }






}