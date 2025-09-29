import 'package:flutter/material.dart';
import '../../screens/account/account_screen.dart';
import '../../screens/account/password/change_password_screen.dart';
import '../../screens/dispute/dispute_screen.dart';
import '../../screens/loans/loan_request_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/signup/signup_screen1.dart';
import '../../screens/home/home_screen.dart';

class AppRouter {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const disputes = '/disputes';
  static const loans = '/loans';
  static const accounts = '/accounts';
  static const String changePassword = '/change-password';


  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    onboarding: (_) => const OnboardingScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen1(),
    home: (_) => const HomeScreen(),
    disputes: (_) => const DisputeScreen(),
    loans: (_) => const LoanRequestScreen(),
    accounts: (_) => const AccountScreen(),
    changePassword: (context) => const ChangePasswordScreen(),
  };
}
