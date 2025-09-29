import 'package:flutter/material.dart';

import '../../../provider/home_provider.dart';

Widget errorState(HomeProvider homeProvider, double screenWidth, double padding) {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Unable to load data',
            style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            homeProvider.errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => homeProvider.fetchHomeData(),
            child: Text('Retry'),
          ),
        ],
      ),
    ),
  );
}
