import 'package:flutter/material.dart';
import 'widget/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Back to Home',style: TextStyle(color: Colors.black38),),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('Notifications', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold
              ),),
            ),
            // Loan Approved Notification
            NotificationCard(
              title: 'Loan request approved',
              date: 'March 21 2025',
              description: 'Your recent loan application has been approved. Our vendor will reach out to you. Your loan repayments will commence upon receipt of the goods.',
              actionText: 'Confirm receipt of goods',
              onActionPressed: () {
                // Handle confirm receipt action
              },
              isImportant: true,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(),
            ),
            // Pending Payment Notification
            NotificationCard(
              title: 'Pending loan payment',
              date: 'April 21, 2025',
              description: 'Your loan 120,000.00 is due for repayment on Wednesday, 29th June 2025',
              isImportant: false,
            ),

            // // Additional sample notifications
            // const SizedBox(height: 16),
            // NotificationCard(
            //   title: 'Payment received',
            //   date: 'April 15, 2025',
            //   description: 'Your payment of N25,000.00 has been successfully processed.',
            //   isImportant: false,
            // ),
            //
            // const SizedBox(height: 16),
            // NotificationCard(
            //   title: 'Account update required',
            //   date: 'April 10, 2025',
            //   description: 'Please update your profile information to continue using our services.',
            //   actionText: 'Update Profile',
            //   onActionPressed: () {
            //     // Handle update profile action
            //   },
            //   isImportant: true,
            // ),
          ],
        ),
      ),
    );
  }

}