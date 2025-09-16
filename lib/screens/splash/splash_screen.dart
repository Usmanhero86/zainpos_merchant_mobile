import 'package:flutter/material.dart';
import '../../app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRouter.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // screen size
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0052CC), Color(0xFF1976D2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Push logo roughly to mid-screen regardless of device height
            SizedBox(height: height * 0.35),

            // Center logo image with responsive sizing
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Image.asset(
                'assets/logos/zainpos.png',
                width: width * 0.6,      // 60% of screen width
                height: height * 0.1,    // 10% of screen height
                fit: BoxFit.contain,
              ),
            ),

            const Spacer(),

            // Bottom license text & CBN logo
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Licensed by Central Bank of Nigeria (CBN)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.035, // responsive font size
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Image.asset(
                    'assets/logos/cbn2.png',
                    height: height * 0.03, // 3% of screen height
                    width: height * 0.03,
                    fit: BoxFit.contain,
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
