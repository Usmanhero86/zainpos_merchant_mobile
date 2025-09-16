import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool isImportant;
  final Color? importantColor;
  final Color? regularColor;

  const NotificationCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    this.actionText,
    this.onActionPressed,
    required this.isImportant,
    this.importantColor,
    this.regularColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Date
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Image(image: AssetImage('assets/logos/Ellipse.png'),
                height: 8, width: 8,)
              ],
            ),
            SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 12),

            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
            SizedBox(height: 12),

            // Action Button (if provided)
            if (actionText != null && onActionPressed != null)
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: onActionPressed,
                  child: Text(actionText!, style: TextStyle(
                    color: Colors.blue
                  ),),
                ),
              ),
          ],
        ),
      ),
    );
  }
}