import 'package:flutter/material.dart';
import '../../../provider/home_provider.dart';

class ErrorState extends StatelessWidget {
  final HomeProvider homeProvider;
  final double screenWidth;
  final double padding;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.homeProvider,
    required this.screenWidth,
    required this.padding,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400]
            ),
            SizedBox(height: 16),
            Text(
              'Unable to load data',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                homeProvider.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry ?? () => homeProvider.fetchHomeData(),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}