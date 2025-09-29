import 'package:flutter/material.dart';
import '../widgets/password_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final isLarge = size.width >= 900;

    final horizontalPadding = isLarge
        ? size.width * 0.2
        : isTablet
        ? size.width * 0.1
        : 16.0;

    final titleFontSize = isLarge
        ? 28.0
        : isTablet
        ? 22.0
        : 18.0;

    final buttonHeight = isTablet ? 56.0 : 48.0;
    final spacing = isTablet ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            Flexible(
              child: Text(
                'Back to Account',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.black38,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height * 0.85),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: spacing / 2),
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(height: 24, thickness: 1),

                  // Input fields
                  const PasswordField(hint: 'Enter Current Password'),
                  SizedBox(height: spacing),
                  const PasswordField(hint: 'Enter New Password'),
                  SizedBox(height: spacing),
                  const PasswordField(hint: 'Confirm New Password'),
                  SizedBox(height: spacing),

                  // Info text
                  Text(
                    'You will be logged out once your password is changed and you can sign in with your new password.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      height: 1.4,
                      fontSize: isTablet ? 15 : null,
                    ),
                  ),

                  const Spacer(),

                  // Change Password Button
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: integrate API call here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
