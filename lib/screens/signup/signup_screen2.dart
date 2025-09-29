import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/app/contants/u_strings.dart';
import 'package:zainpos_merchant_mobile/screens/login/login_screen.dart';
import '../../app/routes/app_routes.dart';
import '../../widgets/build_form.dart';
import '../../widgets/c_button.dart';
import '../../widgets/cbn_license_row.dart';
import '../../widgets/signup_header.dart';
import 'signup_screen3.dart';

class SecondSignupScreen extends StatefulWidget {
  const SecondSignupScreen({super.key});

  @override
  State<SecondSignupScreen> createState() => _SecondSignupScreenState();
}

class _SecondSignupScreenState extends State<SecondSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedId;
  final List<String> _id = ['National ID', 'Drivers License','Voters Card', 'Passport'];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),

               SignupHeader(
                title: 'Create an Account',
                subtitle: 'Create your account on ZAINPOS',
                step: 'STEP 2/4',
              ),

              SizedBox(height: screenHeight * 0.03),

              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomFormField(
                        hintText: 'Enter first name',
                        controller: _firstNameController,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      CustomFormField(
                        hintText: 'Enter Last Name',
                        controller: _lastNameController,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      CustomFormField(
                        hintText: 'Enter Phone Number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      CustomFormField(
                        hintText: 'Bvn',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "Please enter email";
                        //   }
                        //   final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        //   if (!regex.hasMatch(value)) {
                        //     return "Enter a valid email";
                        //   }
                        //   return null;
                        // },
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      CustomFormField(
                        hintText: 'Enter Email Address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "Please enter email";
                        //   }
                        //   final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        //   if (!regex.hasMatch(value)) {
                        //     return "Enter a valid email";
                        //   }
                        //   return null;
                        // },
                      ),

                      SizedBox(height: screenHeight * 0.02),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          value: _selectedId,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.015,
                            ),
                            hintText: 'Select Identification Type',
                          ),
                          items: _id.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedId = newValue;
                            });
                          },
                          // validator: (value) =>
                          // value == null ? 'Please select your gender' : null,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      CButton(
                          text: 'Submit',
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>  LoginScreen()),
                            );
                          }),
                      SizedBox(height: screenHeight * 0.03),
                      
                      Text('By continuing, you agree to the $terms and \n $policy')

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
