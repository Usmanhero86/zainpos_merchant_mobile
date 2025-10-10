import 'package:flutter/material.dart';

void showForgotPinDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final mediaQuery = MediaQuery.of(context);
      final width = mediaQuery.size.width;
      final height = mediaQuery.size.height;
      final isPortrait = mediaQuery.orientation == Orientation.portrait;

      // Responsive sizing based on screen dimensions
      final dialogWidth = width * (isPortrait ? 0.85 : 0.65);
      final horizontalPadding = width * 0.05;
      final iconSize = width * (width > 600 ? 0.08 : 0.12);
      final titleFontSize = width * (width > 600 ? 0.04 : 0.05);
      final bodyFontSize = width * (width > 600 ? 0.035 : 0.037);
      final buttonFontSize = width * (width > 600 ? 0.035 : 0.04);

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(
            maxWidth: 500, // Maximum width for large screens
            minWidth: 300, // Minimum width for very small screens
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: height * 0.025,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Section
                CircleAvatar(
                  radius: iconSize,
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  child: Icon(
                      Icons.lock_reset_rounded,
                      size: iconSize * 1.25,
                      color: Colors.orange
                  ),
                ),

                SizedBox(height: height * 0.02),

                // Title
                Text(
                  'Forgot Transaction PIN?',
                  style: TextStyle(
                      fontSize: titleFontSize.clamp(18, 24), // Min and max limits
                      fontWeight: FontWeight.bold,
                      color: Colors.black87
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: height * 0.015),

                // Description
                Text(
                  'No worries! Please contact our support team to reset your transaction PIN.',
                  style: TextStyle(
                    fontSize: bodyFontSize.clamp(14, 18), // Min and max limits
                    color: Colors.black54,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: height * 0.03),

                // Buttons - Responsive layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    final buttonWidth = constraints.maxWidth;
                    final useColumnLayout = buttonWidth < 400; // Stack buttons vertically on small widths

                    return useColumnLayout
                        ? Column(
                      children: [
                        // Contact Support Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.02,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              // Add your contact support logic here
                            },
                            child: Text(
                              'Contact Support',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: buttonFontSize.clamp(14, 16),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.01),

                        // Cancel Button
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.018,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: buttonFontSize.clamp(14, 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel Button
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.018,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: buttonFontSize.clamp(14, 16),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: width * 0.03),

                        // Contact Support Button
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.02,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              // Add your contact support logic here
                            },
                            child: Text(
                              'Contact Support',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: buttonFontSize.clamp(14, 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}