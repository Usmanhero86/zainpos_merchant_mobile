import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/provider/auth_provider.dart';
import 'package:zainpos_merchant_mobile/provider/bank_deposit_provider.dart';
import 'package:zainpos_merchant_mobile/provider/bank_list_provider.dart';
import 'package:zainpos_merchant_mobile/provider/change_password_provider.dart';
import 'package:zainpos_merchant_mobile/provider/home_provider.dart';
import 'package:zainpos_merchant_mobile/provider/login_provider.dart';
import 'package:zainpos_merchant_mobile/provider/onboarding_provider.dart';
import 'package:zainpos_merchant_mobile/provider/card_purchase_provider.dart';
import 'package:zainpos_merchant_mobile/provider/payout_provider.dart';
import 'package:zainpos_merchant_mobile/provider/terminal_provider.dart';
import 'package:zainpos_merchant_mobile/services/api/api_service.dart';
import 'app/routes/app_routes.dart';

void main() {
  runApp(const ZainPosApp());
}

class ZainPosApp extends StatelessWidget {
  const ZainPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => CardPurchaseProvider()),
        ChangeNotifierProvider(create: (_) => BankDepositHistoryProvider(apiService: ApiService())),
        ChangeNotifierProvider(create: (_) => PayoutProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => BankListProvider()),
        ChangeNotifierProvider(create: (_) => TerminalProvider(apiService:ApiService())),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider(apiService: ApiService()),),

      ],
      child: MaterialApp(
        title: 'ZainPos Merchant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
        ),
        initialRoute: AppRouter.splash,
        routes: AppRouter.routes,
      ),
    );
  }
}
