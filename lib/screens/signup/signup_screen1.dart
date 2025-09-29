import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/widgets/c_button.dart';
import '../../app/routes/app_routes.dart';
import '../../widgets/build_form.dart';
import '../../widgets/cbn_license_row.dart';
import '../../widgets/signup_header.dart';
import '../login/login_screen.dart';
import 'signup_screen2.dart';

class SignupScreen1 extends StatefulWidget {
  const SignupScreen1({super.key});

  @override
  State<SignupScreen1> createState() => _SignupScreen1State();
}

class _SignupScreen1State extends State<SignupScreen1> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _cacController = TextEditingController();
  String? _selectedBusinessType;

  final List<String> _businessTypes = [
    'Retail',
    'Restaurant',
    'Service Provider',
    'E-commerce',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              SignupHeader(
                title: 'Create an Account',
                subtitle: 'Create your account on ZAINPOS',
                step: 'STEP 1/4',
              ),

              SizedBox(height: screenHeight * 0.03),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomFormField(
                      hintText: 'Enter Business Name',
                      controller: _businessNameController,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    CustomFormField(
                      hintText: 'Enter Business Address',
                      controller: _businessAddressController,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedBusinessType,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.015,
                          ),
                          hintText: 'Select Business Type',
                        ),
                        items: _businessTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedBusinessType = newValue;
                          });
                        },
                        // validator: (value) =>
                        // value == null ? 'Please select a business type' : null,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    CustomFormField(
                      hintText: 'Enter CAC No',
                      controller: _cacController,
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    CButton(
                        text: 'Continue',
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (_) =>  SecondSignupScreen()),
                          );
                        }),
                    SizedBox(height: screenHeight * 0.03),

                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        AppRouter.login,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              CbnLicenseRow(),
            ],
          ),
        ),
      ),
    );
  }
}
