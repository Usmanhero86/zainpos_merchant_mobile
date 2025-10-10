import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final double padding;
  final String title;
  final String description;
  final VoidCallback? onAction;
  final String actionText;

  const EmptyState({
    super.key,
    this.padding = 24.0,
    this.title = 'No transactions yet',
    this.description = 'Your recent transactions will appear here',
    this.onAction,
    this.actionText = 'Refresh',
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
                Icons.receipt_long_outlined,
                size: 72,
                color: Colors.grey[400]
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  height: 1.4,
                ),
              ),
            ),
            if (onAction != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: onAction,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(actionText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}