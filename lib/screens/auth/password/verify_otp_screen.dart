import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../provider/otp_provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String secretKey;

  const OtpVerificationScreen({super.key,required this.email, required this.secretKey,});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String enteredOtp = "";

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please enter the code sent\n to ***** ***456",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: size.height * 0.04),

              Pinput(
                length: 6,
                showCursor: true,
                onCompleted: (pin) {
                  setState(() => enteredOtp = pin);
                },
              ),

              SizedBox(height: size.height * 0.02),

              TextButton(
                onPressed: () async {
                  final otpProvider = Provider.of<OtpProvider>(context, listen: false);

                  await otpProvider.resendOtp(
                    email: widget.email,
                    secretKey: widget.secretKey,
                  );

                  if (otpProvider.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(otpProvider.error!)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          otpProvider.resendOtpResponse?.message ?? "OTP resent successfully",
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  "Resend code",
                  style: TextStyle(color: Colors.red),
                ),
              ),

              SizedBox(height: size.height * 0.04),

              otpProvider.isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                height: size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () async {
                    if (enteredOtp.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enter OTP")),
                      );
                      return;
                    }

                    await otpProvider.verifyOtp(
                      email: widget.email,
                      otp: enteredOtp,
                      secretKey: widget.secretKey,
                    );

                    if (otpProvider.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(otpProvider.error!)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              otpProvider.otpResponse?.message ?? "Verified"),
                        ),
                      );
                      // TODO: Navigate to reset password or home
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Verify",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
