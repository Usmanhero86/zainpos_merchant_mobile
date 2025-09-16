import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/account/account_screen.dart';
import 'package:zainpos_merchant_mobile/screens/dispute/dispute_screen.dart';
import 'package:zainpos_merchant_mobile/screens/loans/loan_request_screen.dart';

class MoreTab extends StatefulWidget {
  final Function(int) onOptionSelected;

  const MoreTab({super.key, required this.onOptionSelected});

  @override
  State<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends State<MoreTab> {
  void showOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              _buildOptionButton(
                context,
                icon: Icons.gavel,
                title: 'Disputes',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=> DisputeScreen())) ;// Close the dialog
                  widget.onOptionSelected(0); // Notify parent to show disputes
                },
              ),
              _buildOptionButton(
                context,
                icon: Icons.credit_score,
                title: 'Loans',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=> LoanRequestScreen())) ;// Close the dialog
                  widget.onOptionSelected(1); // Notify parent to show loans
                },
              ),
              _buildOptionButton(
                context,
                icon: Icons.person,
                title: 'Accounts',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=> AccountScreen())); // Close the dialog
                  widget.onOptionSelected(2); // Notify parent to show accounts
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ... _buildOptionButton remains the same ...

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showOptionsDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(), // Empty container
    );
  }
}
Widget _buildOptionButton(BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding:  EdgeInsets.all(3.0),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.blue),
        label: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          alignment: AlignmentDirectional.centerStart,
          backgroundColor: Colors.white,
          padding:  EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
  );
}