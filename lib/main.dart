import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/provider/auth_provider.dart';
import 'package:zainpos_merchant_mobile/provider/bank_deposit_provider.dart';
import 'package:zainpos_merchant_mobile/provider/bank_list_provider.dart';
import 'package:zainpos_merchant_mobile/provider/card_payment_provider.dart';
import 'package:zainpos_merchant_mobile/provider/change_password_provider.dart';
import 'package:zainpos_merchant_mobile/provider/dispute_provider.dart';
import 'package:zainpos_merchant_mobile/provider/home_provider.dart';
import 'package:zainpos_merchant_mobile/provider/login_provider.dart';
import 'package:zainpos_merchant_mobile/provider/onboarding_provider.dart';
import 'package:zainpos_merchant_mobile/provider/card_purchase_provider.dart';
import 'package:zainpos_merchant_mobile/provider/otp_provider.dart';
import 'package:zainpos_merchant_mobile/provider/otp_request_provider.dart';
import 'package:zainpos_merchant_mobile/provider/password_provider.dart';
import 'package:zainpos_merchant_mobile/provider/payout_provider.dart';
import 'package:zainpos_merchant_mobile/provider/pin_provider.dart';
import 'package:zainpos_merchant_mobile/provider/reset_password_provider.dart';
import 'package:zainpos_merchant_mobile/provider/serach_Filter_provider.dart';
import 'package:zainpos_merchant_mobile/provider/settings_provider.dart';
import 'package:zainpos_merchant_mobile/provider/terminal_provider.dart';
import 'package:zainpos_merchant_mobile/provider/wallet_balance_provider.dart';
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
        // Authentication & User Management
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()..loadTokenAndUser()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),

        // Transaction Providers
        ChangeNotifierProvider(create: (_) => CardPurchaseProvider()),
        ChangeNotifierProvider(create: (_) => BankDepositHistoryProvider(apiService: ApiService())),
        ChangeNotifierProvider(create: (_) => PayoutProvider()),
        ChangeNotifierProvider(create: (_) => DisputeProvider()),
        ChangeNotifierProvider(create: (context) => PinProvider()),
        ChangeNotifierProvider(create: (context) => CardPaymentProvider()),
        ChangeNotifierProvider(create: (_) => WalletBalanceProvider()),

        // Terminal & Bank Management
        ChangeNotifierProvider(create: (_) => TerminalProvider(apiService: ApiService())),
        ChangeNotifierProvider(create: (_) => BankListProvider()),
        ChangeNotifierProvider(create: (context) => SearchFilterProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),

        // Home & Dashboard
        ChangeNotifierProvider(create: (_) => HomeProvider()),

        // Security & Password Management
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider(apiService: ApiService())),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider(apiService: ApiService())),

        // OTP Services
        ChangeNotifierProvider(create: (_) => OtpProvider(apiService: ApiService())),
        ChangeNotifierProvider(create: (_) => OtpRequestProvider()),
      ],
      child: MaterialApp(
        title: 'ZainPos Merchant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          useMaterial3: true,
        ),
        initialRoute: AppRouter.splash,
        routes: AppRouter.routes,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}