import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/password/change_password_screen.dart';
import '../auth/password/set_pin_screen.dart';
import 'widgets/action_button.dart';
import '../../widgets/build_info_section.dart';
import '../../provider/login_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final user = loginProvider.currentUser;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final double titleFont = width * 0.055;
    final double spacing = height * 0.02;

    // Show loading if user data is not loaded yet
    if (user == null && loginProvider.isLoggedIn) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: titleFont,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Profile header
            CircleAvatar(radius: 64,
              backgroundColor: Colors.blue[50],
              child: Text(
                user?.initials ?? 'U',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: spacing),
            Text(user?.fullName ?? 'User Name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: spacing * 1.2),

            // Business Information Section
            BuildInfoSection(
              title: 'Business Name',
              content: user?.businessName ?? 'Business Name',
              titleFontSize: 12,
              contentFontSize: 14,
            ),
            SizedBox(height: spacing),

            BuildInfoSection(
              title: 'Email Address',
              content: user?.email ?? 'user@example.com',
              titleFontSize: 12,
              contentFontSize: 14,
            ),
            SizedBox(height: spacing),

            BuildInfoSection(
              title: 'Phone Number',
              content: user?.phoneNumber.isNotEmpty == true
                  ? formatPhoneNumber(user!.phoneNumber)
                  : 'Not provided',
              titleFontSize: 12,
              contentFontSize: 14,
            ),

            SizedBox(height: spacing),

            BuildInfoSection(
              title: 'Username',
              content: user?.username ?? 'username',
              titleFontSize: 12,
              contentFontSize: 14,
            ),

            SizedBox(height: spacing),

            BuildInfoSection(
              title: 'Role',
              content: user?.role ?? 'Merchant',
              titleFontSize: 12,
              contentFontSize: 14,
            ),

            SizedBox(height: spacing),
            Divider(thickness: 1, height: spacing * 2),

            // Action buttons
            ActionButton(
              icon: Image.asset(
                'assets/logos/featuredIcon.png',
                height: 38, width: 38),
              text: 'Change Password',
              textSize: 14,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangePasswordScreen()));
              },
            ),
            SizedBox(height: spacing),

            ActionButton(icon: Image.asset(
                'assets/logos/FeaturedIcon2.png',
                height:38, width: 38),
              text: 'Set PIN',
              textSize: 14,
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> SetPinScreen()));}),
            SizedBox(height: spacing),

            ActionButton(icon: Image.asset('assets/logos/FeaturedIcon3.png', height:38, width: 38),
              text: 'Log Out', textSize: 14, onTap: () {
                showLogoutDialog(context, loginProvider);
              },
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  String formatPhoneNumber(String phone) {
    // Format phone number for better display
    if (phone.startsWith('+234')) {
      return '+234 ${phone.substring(4, 7)} ${phone.substring(7, 10)}-${phone.substring(10)}';
    }
    return phone;
  }

  void showLogoutDialog(BuildContext context, LoginProvider loginProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                loginProvider.logout();
                // Navigate to login screen
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                        (route) => false
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}