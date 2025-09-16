import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? step;

  const SignupHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.step,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth * 0.06;
    final subtitleFontSize = screenWidth * 0.04;

    return Column(
crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 50),
              if (step != null) ...[
    SizedBox(height: 10),
    Text(
    step!,
    style: TextStyle(
    color: Colors.black,
    fontSize: 14,
    ),
    ),
            ],
    ]
          ),
          SizedBox(height: screenWidth * 0.01),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey,
              fontSize: subtitleFontSize,
            ),
          ),


          ]

    );
  }
}
