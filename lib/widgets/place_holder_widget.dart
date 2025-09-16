import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: Colors.blue.shade700),
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        // SizedBox(height: 16),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 32.0),
        //   child: Text(
        //     "This section would contain detailed information and functionality related to this service.",
        //     textAlign: TextAlign.center,
        //     style: TextStyle(fontSize: 16, color: Colors.grey),
        //   ),
        // ),
      ],
    );
  }
}
