import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/provider/auth_provider.dart';
import 'package:zainpos_merchant_mobile/provider/onboarding_provider.dart';
import 'app/routes/app_routes.dart';

void main() {
  runApp( ZainPosApp());
}

class ZainPosApp extends StatelessWidget {
  const ZainPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ],
      child: MaterialApp(
        title: "ZainPos Merchant",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins'),
        initialRoute: AppRouter.splash,
        routes: AppRouter.routes,
      ),
    );
  }
}
