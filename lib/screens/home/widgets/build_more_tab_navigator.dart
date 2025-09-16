import 'package:flutter/material.dart';
import '../../account/account_screen.dart';
import '../../dispute/dispute_screen.dart';
import '../../loans/loan_request_screen.dart';

// Accept the key from the caller
Widget buildMoreTabNavigator(GlobalKey<NavigatorState> navigatorKey) {
  return Navigator(
    key: navigatorKey,
    onGenerateRoute: (RouteSettings settings) {
      Widget page;
      switch (settings.name) {
        case '/disputes':
          page = const DisputeScreen();
          break;
        case '/loans':
          page = const LoanRequestScreen();
          break;
        case '/accounts':
          page = const AccountScreen();
          break;
        case '/':
        default:
        // The first page of the More tab – could be a placeholder or menu
          page = const SizedBox.shrink();
      }
      return MaterialPageRoute(builder: (_) => page);
    },
  );
}
