import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/change_password_provider.dart';
import '../../../provider/login_provider.dart';
import '../widgets/password_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    currentCtrl.dispose();
    newCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  void _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (newCtrl.text != confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final provider = context.read<ChangePasswordProvider>();

    await provider.changePassword(
      currentPassword: currentCtrl.text.trim(),
      newPassword: newCtrl.text.trim(),
      confirmPassword: confirmCtrl.text.trim(),
    );

    if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error!)),
      );
    } else if (provider.response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.response!.message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      _logoutAndRedirect();
    }
  }

  void _logoutAndRedirect() async {
    final loginProvider = context.read<LoginProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Logging out...'),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    await loginProvider.logout();

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (route) => false,
      );
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangePasswordProvider>();
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final isDesktop = size.width >= 1024;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isDesktop ? null : AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(
            fontSize: isTablet ? 20 : 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? size.width * 0.1 : 0,
                vertical: isDesktop ? size.height * 0.05 : 0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Container(
                      constraints: isDesktop
                          ? const BoxConstraints(maxWidth: 500)
                          : null,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(isDesktop ? 32 : isTablet ? 24 : 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isDesktop) ...[
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: Icon(
                                        Icons.arrow_back,
                                        size: isTablet ? 28 : 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Change Password',
                                      style: TextStyle(
                                        fontSize: isTablet ? 28 : 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isTablet ? 40 : 32),
                              ],

                              PasswordField(
                                controller: currentCtrl,
                                hint: 'Current Password',
                                validator: _validatePassword,
                              ),
                              SizedBox(height: isDesktop ? 24 : isTablet ? 20 : 16),

                              // New Password
                              PasswordField(
                                controller: newCtrl,
                                hint: 'New Password',
                                validator: _validatePassword,
                              ),
                              SizedBox(height: isDesktop ? 24 : isTablet ? 20 : 16),

                              // Confirm New Password
                              PasswordField(
                                controller: confirmCtrl,
                                hint: 'Confirm New Password',
                                validator: (value) {
                                  if (value != newCtrl.text) {
                                    return 'Passwords do not match';
                                  }
                                  return _validatePassword(value);
                                },
                              ),
                              SizedBox(height: isDesktop ? 32 : isTablet ? 28 : 24),

                              // Change Password Button
                              SizedBox(
                                width: double.infinity,
                                height: isDesktop ? 60 : isTablet ? 56 : 48,
                                child: ElevatedButton(
                                  onPressed: provider.loading ? null : _handleChangePassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF007BFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        isDesktop ? 20 : isTablet ? 16 : 12,
                                      ),
                                    ),
                                  ),
                                  child: provider.loading
                                      ? SizedBox(
                                    width: isDesktop ? 28 : isTablet ? 24 : 20,
                                    height: isDesktop ? 28 : isTablet ? 24 : 20,
                                    child: const CircularProgressIndicator(color: Colors.white),
                                  )
                                      : Text(
                                    'Change Password',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isDesktop ? 18 : isTablet ? 17 : 16,
                                    ),
                                  ),
                                ),
                              ),

                              // Additional security note
                              SizedBox(height: isDesktop ? 24 : isTablet ? 20 : 16),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isDesktop ? 8 : 0,
                                ),
                                child: Text(
                                  'Note: You will be automatically logged out for security purposes after changing your password.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: isDesktop ? 14 : isTablet ? 13 : 12,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}