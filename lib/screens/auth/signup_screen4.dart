// import 'package:flutter/material.dart';
//
// class FourthSignupScreen extends StatefulWidget {
//   const FourthSignupScreen({super.key});
//
//   @override
//   State<FourthSignupScreen> createState() => _FourthSignupScreenState();
// }
//
// class _FourthSignupScreenState extends State<FourthSignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _firstNameController = TextEditingController(text: 'Mustapha');
//   final TextEditingController _lastNameController = TextEditingController(text: 'Oldado');
//   final TextEditingController _phoneNumberController = TextEditingController(text: '08012345667');
//   final TextEditingController _bvnController = TextEditingController(text: '67384889557');
//   final TextEditingController _emailController = TextEditingController(text: 'gidadomustapha@gmail.com');
//   final TextEditingController _idNumberController = TextEditingController(text: '67384889557');
//   String? _selectedIdType = 'National Identity Card';
//   bool _termsAccepted = false;
//
//   final List<String> _idTypes = [
//     'National Identity Card',
//     'Driver\'s License',
//     'International Passport',
//     'Voter\'s Card'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//               // Header section
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(25),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0052cc),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Column(
//                   children: [
//                     Text(
//                       'Create an Account',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       'Create your account on ZAINPOS',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     // Step indicator
//                     StepIndicator(step: 2, totalSteps: 4),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Form section
//               Container(
//                 padding: const EdgeInsets.all(25),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       // First Name field
//                       _buildFormField(
//                         label: 'First Name',
//                         hintText: 'Your first name',
//                         controller: _firstNameController,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your first name';
//                           }
//                           return null;
//                         },
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // Last Name field
//                       _buildFormField(
//                         label: 'Last Name',
//                         hintText: 'Your last name',
//                         controller: _lastNameController,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your last name';
//                           }
//                           return null;
//                         },
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // Phone Number field
//                       _buildFormField(
//                         label: 'Phone Number',
//                         hintText: 'Your phone number',
//                         controller: _phoneNumberController,
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your phone number';
//                           }
//                           if (value.length < 11) {
//                             return 'Please enter a valid phone number';
//                           }
//                           return null;
//                         },
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // BVN field
//                       _buildFormField(
//                         label: 'BVN',
//                         hintText: 'Your Bank Verification Number',
//                         controller: _bvnController,
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your BVN';
//                           }
//                           if (value.length != 11) {
//                             return 'BVN must be 11 digits';
//                           }
//                           return null;
//                         },
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // Email field
//                       _buildFormField(
//                         label: 'Email Address',
//                         hintText: 'Your email address',
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your email address';
//                           }
//                           if (!value.contains('@') || !value.contains('.')) {
//                             return 'Please enter a valid email address';
//                           }
//                           return null;
//                         },
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // Identification Type dropdown
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Identification Type',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Color(0xFF555555),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           DropdownButtonFormField<String>(
//                             value: _selectedIdType,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: const BorderSide(color: Color(0xFF0052cc)),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//                               hint: const Text('Select identification type'),
//                             ),
//                             items: _idTypes.map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             onChanged: (newValue) {
//                               setState(() {
//                                 _selectedIdType = newValue;
//                               });
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please select an identification type';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // ID Number field
//                       _buildFormField(
//                         label: 'ID Number',
//                         hintText: 'Your identification number',
//                         controller: _idNumberController,
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your ID number';
//                           }
//                           return null;
//                         },
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // Terms and conditions
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Checkbox(
//                             value: _termsAccepted,
//                             onChanged: (value) {
//                               setState(() {
//                                 _termsAccepted = value ?? false;
//                               });
//                             },
//                             activeColor: const Color(0xFF0052cc),
//                           ),
//                           const Expanded(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10),
//                               child: Text.rich(
//                                 TextSpan(
//                                   text: 'By continuing, you accept our ',
//                                   style: TextStyle(
//                                     color: Color(0xFF555555),
//                                     fontSize: 14,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: 'Terms of use',
//                                       style: TextStyle(
//                                         color: Color(0xFF0052cc),
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     TextSpan(text: ' and '),
//                                     TextSpan(
//                                       text: 'privacy policy',
//                                       style: TextStyle(
//                                         color: Color(0xFF0052cc),
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     TextSpan(text: '.'),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 25),
//
//                       // Submit button
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate() && _termsAccepted) {
//                               // Submit form
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text('Account created successfully!')),
//                               );
//                             } else if (!_termsAccepted) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text('Please accept the terms and conditions')),
//                               );
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF0052cc),
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: const Text(
//                             'Submit',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // License information
//               const Text(
//                 'Licensed by Central Bank of Nigeria (CBN)',
//                 style: TextStyle(
//                   color: Color(0xFF777777),
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFormField({
//     required String label,
//     required String hintText,
//     required TextEditingController controller,
//     required String? Function(String?) validator,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Color(0xFF555555),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Color(0xFF0052cc)),
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//             hintText: hintText,
//           ),
//           validator: validator,
//         ),
//       ],
//     );
//   }
// }
//
// class StepIndicator extends StatelessWidget {
//   final int step;
//   final int totalSteps;
//
//   const StepIndicator({
//     super.key,
//     required this.step,
//     required this.totalSteps,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         'STEP $step/$totalSteps',
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 14,
//         ),
//       ),
//     );
//   }
// }