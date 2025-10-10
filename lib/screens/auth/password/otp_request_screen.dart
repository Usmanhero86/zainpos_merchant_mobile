import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/screens/account/widgets/password_field.dart';
import '../../../provider/otp_request_provider.dart';

class OtpRequestScreen extends StatefulWidget {
  const OtpRequestScreen({super.key});

  @override
  State<OtpRequestScreen> createState() => _OtpRequestScreenState();
}

class _OtpRequestScreenState extends State<OtpRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<OtpRequestProvider>(
          builder: (context, otpProvider, _) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email field
                  PasswordField(
                    controller: emailController,
                    validator: (val) =>
                    val!.isEmpty ? "Please enter your email" : null,
                    hint: 'Email',
                  ),
                  const SizedBox(height: 24),

                  // Request OTP Button
                  ElevatedButton(
                    onPressed: otpProvider.isLoading
                        ? null
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        await otpProvider.requestOtp(
                            emailController.text,
                          passwordController.text,

                        );

                        if (otpProvider.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: ${otpProvider.error}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                    "OTP Sent Successfully",
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Navigate to verify screen
                          Navigator.pushNamed(context, "/verify-otp");
                        }
                      }
                    },
                    child: otpProvider.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Request OTP"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
