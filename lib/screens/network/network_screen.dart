import 'package:flutter/material.dart';
import '../banks/bank_transfer.dart';
import '../banks/card_screen.dart';

class NetworkSelectionScreen extends StatelessWidget {
   const NetworkSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text('Back to Dashboard', style: TextStyle(
          color: Colors.black38
        ),),

      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             SizedBox(height: 10),
             Text(
              'Network',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
             SizedBox(height: 32),
            Card(
              color: Colors.white,
              child: Column(
                children: [
                  // Bank Transfer Option
                  buildNetworkOption(
                    icon: Image(image: AssetImage('assets/logos/bank.png'),
                    height: 24, width: 24,),
                    title: 'Bank Transfer',
                    description: 'Transfer funds directly from your bank account',
                    onTap: () {
                      // Handle bank transfer selection
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => BankSelectionScreen()));
                    },
                  ),
                  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Divider(),
                  ),
                  // Card Payment Option
                  buildNetworkOption(
                    icon: Image(image: AssetImage('assets/logos/credit-card-01.png'),
                    height: 24, width: 24,),
                    title: 'Card Payment',
                    description: 'Pay using debit or credit card',
                    onTap: () {
                      // Handle card payment selection
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CardPaymentScreen()));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildNetworkOption({
    required Widget icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding:  EdgeInsets.all(16.0),
            child: Row(
              children: [
                icon,
                 SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:  TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       SizedBox(height: 4),
                      Text(
                        description,
                        style:  TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                 Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


