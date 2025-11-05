import 'package:flutter/material.dart';
import '../../../provider/home_provider.dart';
import 'empty_state_widget.dart';
import 'error_widget.dart';
import 'home_content_widget.dart';

class HomeBody extends StatelessWidget {
  final HomeProvider homeProvider;
  final double screenWidth;
  final double screenHeight;
  final double padding;
  final String? accountNumber;

  const HomeBody({
    super.key,
    required this.homeProvider,
    required this.screenWidth,
    required this.screenHeight,
    required this.padding,
    required this.accountNumber,
  });

  @override
  Widget build(BuildContext context) {
    if (homeProvider.isLoading && homeProvider.homeData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (homeProvider.errorMessage.isNotEmpty && homeProvider.homeData == null) {
      return ErrorState(
        homeProvider: homeProvider,
        screenWidth: screenWidth,
        padding: padding,
      );
    }

    if (homeProvider.homeData == null) {
      return EmptyState(
        actionText: 'Load Data',
      );
    }

    return HomeContent(
      homeProvider: homeProvider,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      padding: padding,
      accountNumber: accountNumber,
    );
  }
}