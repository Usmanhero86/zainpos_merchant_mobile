import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.hint,
    this.controller,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  void _toggleVisibility() {
    setState(() => _obscure = !_obscure);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final isDesktop = size.width >= 1024;

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      style: TextStyle(
        fontSize: isDesktop ? 17 : isTablet ? 16 : 14,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          fontSize: isDesktop ? 17 : isTablet ? 16 : 14,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            isDesktop ? 16 : isTablet ? 14 : 12,
          ),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            isDesktop ? 16 : isTablet ? 14 : 12,
          ),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            isDesktop ? 16 : isTablet ? 14 : 12,
          ),
          borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            isDesktop ? 16 : isTablet ? 14 : 12,
          ),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            isDesktop ? 16 : isTablet ? 14 : 12,
          ),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 20 : isTablet ? 18 : 16,
          vertical: isDesktop ? 20 : isTablet ? 18 : 16,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
            size: isDesktop ? 26 : isTablet ? 24 : 20,
          ),
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}