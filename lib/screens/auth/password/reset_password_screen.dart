import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/screens/auth/password/otp_request_screen.dart';
import 'package:zainpos_merchant_mobile/screens/account/widgets/password_field.dart';
import '../../../provider/reset_password_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String secretKey;

  const ResetPasswordScreen({super.key, required this.email, required this.secretKey,});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final otpController = TextEditingController();
  final email = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final resetProvider = Provider.of<ResetPasswordProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///  Show the email (read-only since passed from OTP screen)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.email,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                    ),
                  ),
                ),

                /// OTP field
                PasswordField(
                  controller: otpController,
                  validator: (value) =>
                  value!.isEmpty ? "Enter the OTP" : null,
                  hint: 'OTP',
                ),

                /// New Password
                PasswordField(
                  controller: newPasswordController,
                  hint: 'New Password',
                  validator: (value) =>
                  value!.isEmpty ? "Enter new password" : null,
                ),

                /// Confirm Password
                PasswordField(
                  controller: confirmPasswordController,
                  hint: 'Confirm Password',
                  validator: (value) => value != newPasswordController.text
                      ? "Passwords do not match"
                      : null,
                ),
                const SizedBox(height: 8),

                /// Reset Button
                SizedBox(
                  width: size.width,
                  child: ElevatedButton(
                    onPressed: resetProvider.isLoading
                        ? null
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        await resetProvider.resetPassword(
                          email: widget.email,
                          secretKey: widget.secretKey,
                          otp: otpController.text.trim(),
                          newPassword: newPasswordController.text.trim(),
                          confirmPassword:
                          confirmPasswordController.text.trim(),
                        );

                        if (resetProvider.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(resetProvider.error!)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(resetProvider
                                  .resetResponse?.message ??
                                  "Password reset successful"),
                            ),
                          );

                          /// Navigate to Login or OTP Request Screen
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const OtpRequestScreen()),
                                (route) => false,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: resetProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Reset Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
