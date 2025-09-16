// import 'package:flutter/material.dart';
//
// class ThirdSignupScreen extends StatefulWidget {
//   const ThirdSignupScreen({super.key});
//
//   @override
//   State<ThirdSignupScreen> createState() => _ThirdSignupScreenState();
// }
//
// class _ThirdSignupScreenState extends State<ThirdSignupScreen> {
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
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Business Information section
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
//                 child: Column(
//                   children: [
//                     // Business Name
//                     _buildInfoRow(
//                       label: 'Business Name',
//                       value: 'SIGAO Mustapha Enterprises',
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Business Address
//                     _buildInfoRow(
//                       label: 'Business Address',
//                       value: 'Kano, Nigeria',
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Business Type
//                     _buildInfoRow(
//                       label: 'Business Type',
//                       value: 'Registered Company',
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // CAC Number
//                     _buildInfoRow(
//                       label: 'CAC Number',
//                       value: 'RC 3556476',
//                     ),
//
//                     const SizedBox(height: 30),
//
//                     // Continue button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Proceed to next step
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('Proceeding to next step...')),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF0052cc),
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text(
//                           'Continue',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 25),
//
//                     // Sign in link
//                     GestureDetector(
//                       onTap: () {
//                         // Navigate to sign in screen
//                       },
//                       child: const Text.rich(
//                         TextSpan(
//                           text: 'Already have an account? ',
//                           style: TextStyle(
//                             color: Color(0xFF666666),
//                             fontSize: 15,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: 'Sign in',
//                               style: TextStyle(
//                                 color: Color(0xFF0052cc),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
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
//   Widget _buildInfoRow({required String label, required String value}) {
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
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             border: Border.all(color: const Color(0xFFDDDDDD)),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Color(0xFF333333),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }