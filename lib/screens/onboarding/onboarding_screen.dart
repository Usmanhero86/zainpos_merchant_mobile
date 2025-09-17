import 'dart:async';
import 'package:flutter/material.dart';
import 'widgets/onboarding_page.dart';
import '../../app/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  bool _userSwiped = false;

  final List<OnboardingPage> pages = const [
    OnboardingPage(
      image: "assets/images/onboarding1.png",
      title: "Instant Settlement",
      description:
      "We provide POS terminals that small and large businesses rely on to accept payments from their customers via cards",
    ),
    OnboardingPage(
      image: "assets/images/onboarding2.png",
      title: "Enjoy Lowest Charges",
      description:
      "We provide POS terminals that small and large businesses rely on to accept payments from their customers via cards",
    ),
    OnboardingPage(
      image: "assets/images/onboarding1.png",
      title: "99.9% Reliability",
      description:
      "We provide POS terminals that small and large businesses rely on to accept payments from their customers via cards",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Auto-slide every 3 seconds until user swipes
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_userSwiped && _pageController.hasClients) {
        _currentPage = (_currentPage + 1) % pages.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final buttonHorizontalPadding = screenWidth * 0.08;
    final buttonVerticalPadding = screenHeight * 0.018;
    final spacingBetweenButtons = screenWidth * 0.05;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onPanDown: (_) {
                  setState(() => _userSwiped = true);
                },
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) => pages[index],
                ),
              ),
            ),
        
            SizedBox(height: screenHeight * 0.04),
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonHorizontalPadding,
                        vertical: buttonVerticalPadding,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRouter.login);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.blue,
                          fontWeight: FontWeight.bold,fontSize: screenWidth * 0.04),
                    ),
                  ),
                  SizedBox(width: spacingBetweenButtons),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonHorizontalPadding,
                        vertical: buttonVerticalPadding,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRouter.signup);
                    },
                    child: Text(
                      "Signup",
                      style: TextStyle(
                          color:Colors.white,
                          fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            SizedBox(height: screenHeight * 0.05),
        
            Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Licensed by Central Bank of Nigeria (CBN)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 6),
                  Image.asset(
                    'assets/logos/cbn2.png',
                    height: 20,
                    width: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
