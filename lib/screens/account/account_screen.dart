import 'package:flutter/material.dart';
import 'widgets/action_button.dart';
import '../../widgets/build_info_section.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final double titleFont = width * 0.055;
    final double nameFont = width * 0.07;
    final double smallFont = width * 0.04;
    final double avatarRadius = width * 0.064;
    final double spacing = height * 0.02;

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
            CircleAvatar(
              radius: 64,
              backgroundColor: Colors.blue[50],
              child: Text(
                'GM',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: spacing),
            Text(
              'Gidado Mustapha',
              style: TextStyle(
                fontSize: nameFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing * 1.2),

            // Business Information Section
            BuildInfoSection(
              title: 'Business Name',
              content: 'Gidado Mustapha Enterprises',
              titleFontSize: smallFont,
              contentFontSize: smallFont,
            ),
            SizedBox(height: spacing),

            BuildInfoSection(
              title: 'Address',
              content: 'Kano, Nigeria',
              titleFontSize: smallFont,
              contentFontSize: smallFont,
            ),
            SizedBox(height: spacing),

            BuildInfoSection(
              title: 'Email Address',
              content: 'gidadomustapha@gmail.com',
              titleFontSize: smallFont,
              contentFontSize: smallFont,
            ),
            SizedBox(height: spacing),

            BuildInfoSection(
              title: 'Phone Number',
              content: '+234 901 234-5678',
              titleFontSize: smallFont,
              contentFontSize: smallFont,
            ),

            SizedBox(height: spacing),
            Divider(thickness: 1, height: spacing * 2),

            // Action buttons
            ActionButton(
              icon: Image.asset(
                'assets/logos/featuredIcon.png',
                height: 38,
                width: 38,
              ),
              text: 'Change Password',
              textSize: smallFont,
              onTap: () {},
            ),
            SizedBox(height: spacing),

            ActionButton(
              icon: Image.asset(
                'assets/logos/FeaturedIcon2.png',
                height:38,
                width: 38,
              ),
              text: 'Set PIN',
              textSize: smallFont,
              onTap: () {},
            ),
            SizedBox(height: spacing),

            ActionButton(
              icon: Image.asset(
                'assets/logos/FeaturedIcon3.png',
                height:38,
                width: 38,
              ),
              text: 'Log Out',
              textSize: smallFont,
              onTap: () {},
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }
}
