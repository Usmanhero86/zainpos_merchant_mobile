import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zainpos_merchant_mobile/screens/network/network_screen.dart';
import 'package:zainpos_merchant_mobile/screens/notifications/notifications_screen.dart';
import '../../../widgets/build_transaction_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.04;
    final titleFontSize = screenWidth * 0.05;
    final subtitleFontSize = screenWidth * 0.035;

    final String currentDate =
    DateFormat('EEEE, MMMM d, y').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Gidado',
              style: TextStyle(
                color: Colors.black,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.004),
            Text(
              currentDate,
              style: TextStyle(
                color: Colors.black,
                fontSize: subtitleFontSize,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.blue, size: screenWidth * 0.06),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> NotificationsScreen()));
            },
          ),
          IconButton(
            icon:  Image(
              height: 24, width: 24,
          image: AssetImage('assets/logos/serviceIcon.png'),
          ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> NetworkSelectionScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             TextButton(
               onPressed: (){},
               style: TextButton.styleFrom(
                 minimumSize: Size(250, 40),
                   padding: EdgeInsets.symmetric(horizontal: 16),
                   side: BorderSide(color: Colors.blue)
               ),
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Icon(Icons.mail,color: Colors.blue),
                   SizedBox(width: 5),
                   Text(
                    'Gidado Mustapha Enterprises',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.blue,
                    ),
                             ),
                 ],
               ),
             ),

            // Recent Transactions Title
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  )
                 ),
                 TextButton(onPressed: (){},
                     child: Text('20 Transactions', style: TextStyle(
                       color: Colors.blue
                     ),))
               ],
             ),
             SizedBox(height: 16),

            // Example Transactions
            BuildTransactionCard(
              status: 'SUCCESS',
              reference: 'REF-266526555',
              terminal: 'Nassarawa Terminal',
              type: 'CARD',
              date: '2024-02-16',
              amount: '12,500.00',
              balance: '1,900,070.00',
            ),
             Divider(thickness: 1),
            SizedBox(height: 12),
            BuildTransactionCard(
              status: 'SUCCESS',
              reference: 'REF-266526556',
              amount: 'N2,500.00',
              balance: 'N135,700.00',
              terminal: 'Sharada Terminal-1',
              type: 'TRANSFER',
              date: '2024-02-16',
            ),
             Divider(thickness: 1),
            SizedBox(height: 12),
            BuildTransactionCard(
              status: 'SUCCESS',
              reference: 'REF-266526556',
              amount: 'N2,500.00',
              balance: 'N135,700.00',
              terminal: 'Sharada Terminal-1',
              type: 'TRANSFER',
              date: '2024-02-16',
            ),
             Divider(thickness: 1),
            SizedBox(height: 12),
            BuildTransactionCard(
              status: 'SUCCESS',
              reference: 'REF-266526556',
              amount: 'N2,500.00',
              balance: 'N135,700.00',
              terminal: 'Sharada Terminal-1',
              type: 'TRANSFER',
              date: '2024-02-16',
            ),
             Divider(thickness: 1),
            SizedBox(height: 12),
            BuildTransactionCard(
              status: 'SUCCESS',
              reference: 'REF-266526556',
              amount: 'N2,500.00',
              balance: 'N135,700.00',
              terminal: 'Sharada Terminal-1',
              type: 'TRANSFER',
              date: '2024-02-16',
            ),
          ],
        ),
      ),
    );
  }
}
