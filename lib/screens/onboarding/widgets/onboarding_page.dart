import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final titleFontSize = screenWidth * 0.06;
    final descriptionFontSize = screenWidth * 0.04;
    final verticalSpacing = screenHeight * 0.02;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        //  Full-width image
        SizedBox(
          width: double.infinity,
          height: screenHeight * 0.45,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40)),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),

        SizedBox(height: verticalSpacing),

        // Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        SizedBox(height: verticalSpacing * 0.8),

        // Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ),

        SizedBox(height: verticalSpacing * 2),
      ],
    );
  }
}
