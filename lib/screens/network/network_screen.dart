import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/network/widgets/network_option.dart';
import '../banks/bank_selection_screen.dart';
import '../banks/card_screen.dart';

class NetworkSelectionScreen extends StatelessWidget {
   const NetworkSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  networkOption(
                    icon: Image(image: AssetImage('assets/logos/bank.png'),
                    height: 24, width: 24,),
                    title: 'Bank Transfer',
                    description: 'Transfer funds directly from your bank account',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => BankSelectionScreen(),
                      )
                      );
                    },
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Divider(),
                  ),
                  // Card Payment Option
                  networkOption(
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


}


