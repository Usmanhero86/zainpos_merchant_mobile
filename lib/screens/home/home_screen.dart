import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/home/tabs/home_tab.dart';
import 'package:zainpos_merchant_mobile/screens/home/tabs/terminal_tab.dart';
import 'package:zainpos_merchant_mobile/screens/home/tabs/transaction_tab.dart';
import 'package:zainpos_merchant_mobile/screens/home/widgets/build_more_tab_navigator.dart';
import 'package:zainpos_merchant_mobile/screens/home/widgets/build_option_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<NavigatorState> moreTabNavigatorKey = GlobalKey<NavigatorState>();

  final List<Widget> _pages = [
    HomeTab(),
    TransactionsTab(),
    TerminalsTab(),
    SizedBox.shrink(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentIndex == 3) {
        showOptionsDialog();
      }
    });
  }

  void showOptionsDialog() {
    final size = MediaQuery.of(context).size;
    final sheetPadding = size.width * 0.04;
    final handleWidth = size.width * 0.1;
    final handleHeight = size.height * 0.005;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(sheetPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: handleWidth,
                height: handleHeight,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(handleHeight),
                ),
              ),
              SizedBox(height: size.height * 0.015),

              // Buttons scale with width
              buildOptionButton(
                icon: Image.asset('assets/logos/coins-swap-01.png',
                    height: size.width * 0.06, width: size.width * 0.06),
                title: 'Disputes',
                onPressed: () {
                  Navigator.pop(context);
                  moreTabNavigatorKey.currentState!.pushNamed('/disputes');
                },
              ),
              SizedBox(height: size.height * 0.01),
              buildOptionButton(
                icon: Image.asset('assets/logos/coins-swap-01.png',
                    height: size.width * 0.06, width: size.width * 0.06),
                title: 'Loans',
                onPressed: () {
                  Navigator.pop(context);
                  moreTabNavigatorKey.currentState!.pushNamed('/loans');
                },
              ),
              SizedBox(height: size.height * 0.01),
              buildOptionButton(
                icon: Icon(Icons.person,
                    size: size.width * 0.06, color: Colors.blue),
                title: 'Accounts',
                onPressed: () {
                  Navigator.pop(context);
                  moreTabNavigatorKey.currentState!.pushNamed('/accounts');
                },
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    Widget getCurrentPage() {
      if (_currentIndex == 3) {
        return buildMoreTabNavigator(moreTabNavigatorKey);
      }
      return _pages[_currentIndex];
    }

    return Scaffold(
      body: getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 3) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showOptionsDialog();
            });
          }
        },
        selectedItemColor: const Color(0xFF0052cc),
        unselectedItemColor: const Color(0xFF777777),
        iconSize: screenWidth * 0.07, // scales with screen width
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/logos/bar-chart-square-02.png',
              height: screenWidth * 0.06,
              width: screenWidth * 0.06,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/logos/bar-chart-01.png',
              height: screenWidth * 0.06,
              width: screenWidth * 0.06,
            ),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/logos/terminalsIcon.png',
              height: screenWidth * 0.06,
              width: screenWidth * 0.06,
            ),
            label: 'Terminals',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/logos/Variant4.png',
              height: screenWidth * 0.06,
              width: screenWidth * 0.06,
            ),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
