import 'package:flutter/material.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen1.dart';
import '../../screens/home/home_screen.dart';

class AppRouter {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const transactions = '/transactions';
  static const terminal = '/terminal';
  static const more = '/more';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) =>  SplashScreen(),
    onboarding: (_) =>  OnboardingScreen(),
    login: (_) =>  LoginScreen(),
    signup: (_) =>  SignupScreen1(),
    home: (_) =>  HomeScreen(),
    // transactions: (_) =>  TransactionsTab(),
    // terminal: (_) =>  TerminalScreen(),
    // more: (_) =>  MoreScreen(),
  };
}
