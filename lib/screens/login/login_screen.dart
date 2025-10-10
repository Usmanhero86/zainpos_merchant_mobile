import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/login_provider.dart';
import '../../app/routes/app_routes.dart';
import '../../services/api/api_service.dart';
import '../../widgets/cbn_license_row.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.04,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color:Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Sign in to your account on ZAINPOS",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),

                // Error Message
                if (loginProvider.errorMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding:  EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[600]),
                         SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loginProvider.errorMessage,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red[600]),
                          onPressed: () => loginProvider.clearError(),
                          iconSize: 18,
                        ),
                      ],
                    ),
                  ),
                if (loginProvider.errorMessage.isNotEmpty)
                  SizedBox(height: screenHeight * 0.02),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter user email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.018,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.018,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),


                SizedBox(height: screenHeight * 0.02),

                // Login Button
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 320,
                    height:54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color(0xFF0052cc),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: loginProvider.isLoading
                          ? null
                          : () => handleLogin(loginProvider),
                      child: loginProvider.isLoading
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                          : Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.008),
                // Forgot password
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/reset-password');
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14
                      ),
                    ),
                  ),

                ),
                SizedBox(height: screenHeight * 0.2),

                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 320,
                    height: 54,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        side:  BorderSide(color: Color(0xFF0052cc)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.signup);
                      },
                      child: Text(
                        "Create an Account",
                        style: TextStyle(
                          fontSize: 14,
                          color:  Color(0xFF0052cc),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                 CbnLicenseRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleLogin(LoginProvider loginProvider) async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final success = await loginProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && context.mounted) {
        final token = loginProvider.authToken;
        ApiService().authToken = token;
        debugPrint("User token: $token");
        Navigator.pushReplacementNamed(context, AppRouter.home);
      }
    }
  }

  void _showForgotPasswordDialog(LoginProvider loginProvider) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text("Reset Password"),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration:  InputDecoration(
              labelText: "Enter your email",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final success = await loginProvider.resetPassword(
                  emailController.text.trim(),
                );
                if (success && context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('Password reset instructions sent to your email'),
                    ),
                  );
                }
              }
            },
            child:  Text("Send Instructions"),
          ),
        ],
      ),
    );
  }
}