import 'package:flutter/material.dart';
import '../dispute/widgets/dispute_option_button.dart';

class MoreOptionsScreen extends StatelessWidget {
  final Function(int) onOptionSelected;

  const MoreOptionsScreen({super.key, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DisputeOptionButton(
              icon: Icons.gavel,
              title: 'Disputes',
              onTap: () => onOptionSelected(3), // Navigate to Disputes screen
            ),
            DisputeOptionButton(
              icon: Icons.credit_score,
              title: 'Loans',
              onTap: () => onOptionSelected(4), // Navigate to Loans screen
            ),
            DisputeOptionButton(
              icon: Icons.account_balance,
              title: 'Accounts',
              onTap: () => onOptionSelected(5), // Navigate to Accounts screen
            ),
          ],
        ),
      ),
    );

  }

}