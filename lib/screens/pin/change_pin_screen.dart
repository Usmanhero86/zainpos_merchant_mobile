import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/pin_provider.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  // Separate visibility states for each field
  bool _isCurrentPinVisible = false;
  bool _isNewPinVisible = false;
  bool _isConfirmPinVisible = false;

  @override
  Widget build(BuildContext context) {
    final pinProvider = Provider.of<PinProvider>(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1200;

    // Responsive sizing
    final horizontalPadding = isDesktop ? 32.0 : isTablet ? 24.0 : 16.0;
    final verticalPadding = isDesktop ? 24.0 : isTablet ? 20.0 : 16.0;
    final fieldHeight = isTablet ? 70.0 : 60.0;
    final buttonHeight = isTablet ? 55.0 : 50.0;
    final fontSize = isTablet ? 18.0 : 16.0;
    final iconSize = isTablet ? 24.0 : 20.0;
    final borderRadius = isTablet ? 16.0 : 12.0;

    // Calculate content padding for text fields
    final contentPadding = EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: isTablet ? 20.0 : 16.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Transaction PIN',
          style: TextStyle(
            fontSize: isTablet ? 20.0 : 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: !isTablet,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height -
                (AppBar().preferredSize.height + MediaQuery.of(context).padding.top) -
                verticalPadding * 2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isDesktop) ...[
                const SizedBox(height: 40),
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),
                Text(
                  'Change Your Transaction PIN',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your current PIN and set a new one',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
              ],

              // Responsive layout for form fields
              if (isDesktop)
                _buildDesktopLayout(pinProvider, fieldHeight, fontSize, borderRadius, contentPadding)
              else
                _buildMobileLayout(pinProvider, fieldHeight, fontSize, borderRadius, contentPadding),

              const SizedBox(height: 32),

              // Error message
              if (pinProvider.errorMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
                  margin: EdgeInsets.only(bottom: isTablet ? 20.0 : 16.0),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red, size: iconSize),
                      SizedBox(width: isTablet ? 12.0 : 8.0),
                      Expanded(
                        child: Text(
                          pinProvider.errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: isTablet ? 16.0 : 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Update button
              SizedBox(
                width: isDesktop ? size.width * 0.4 : double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: pinProvider.isLoading ? null : _updatePin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    elevation: 2,
                  ),
                  child: pinProvider.isLoading
                      ? SizedBox(
                    height: isTablet ? 24.0 : 20.0,
                    width: isTablet ? 24.0 : 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
                    'Update PIN',
                    style: TextStyle(
                      fontSize: isTablet ? 18.0 : 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Success message
              if (pinProvider.pinUpdated && pinProvider.lastResponse != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
                  margin: EdgeInsets.only(top: isTablet ? 20.0 : 16.0),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: iconSize),
                      SizedBox(width: isTablet ? 12.0 : 8.0),
                      Expanded(
                        child: Text(
                          pinProvider.lastResponse!.message,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: isTablet ? 16.0 : 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (isDesktop) const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
      PinProvider pinProvider,
      double fieldHeight,
      double fontSize,
      double borderRadius,
      EdgeInsets contentPadding,
      ) {
    return Column(
      children: [
        // Current PIN
        SizedBox(
          height: fieldHeight,
          child: TextFormField(
            controller: _currentPinController,
            decoration: InputDecoration(
              hintText: 'Current PIN',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: contentPadding,
              suffixIcon: IconButton(
                icon: Icon(
                  _isCurrentPinVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[600],
                  size: fontSize,
                ),
                onPressed: () {
                  setState(() {
                    _isCurrentPinVisible = !_isCurrentPinVisible;
                  });
                },
              ),
            ),
            keyboardType: TextInputType.number,
            obscureText: !_isCurrentPinVisible,
            maxLength: 4,
            style: TextStyle(fontSize: fontSize),
          ),
        ),

        const SizedBox(height: 16),

        // New PIN
        SizedBox(
          height: fieldHeight,
          child: TextFormField(
            controller: _newPinController,
            decoration: InputDecoration(
              hintText: 'New PIN',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: contentPadding,
              suffixIcon: IconButton(
                icon: Icon(
                  _isNewPinVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[600],
                  size: fontSize,
                ),
                onPressed: () {
                  setState(() {
                    _isNewPinVisible = !_isNewPinVisible;
                  });
                },
              ),
            ),
            keyboardType: TextInputType.number,
            obscureText: !_isNewPinVisible,
            maxLength: 4,
            style: TextStyle(fontSize: fontSize),
          ),
        ),

        const SizedBox(height: 16),

        // Confirm PIN
        SizedBox(
          height: fieldHeight,
          child: TextFormField(
            controller: _confirmPinController,
            decoration: InputDecoration(
              hintText: 'Confirm New PIN',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: contentPadding,
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPinVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[600],
                  size: fontSize,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPinVisible = !_isConfirmPinVisible;
                  });
                },
              ),
            ),
            keyboardType: TextInputType.number,
            obscureText: !_isConfirmPinVisible,
            maxLength: 4,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
      PinProvider pinProvider,
      double fieldHeight,
      double fontSize,
      double borderRadius,
      EdgeInsets contentPadding,
      ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Current PIN
          SizedBox(
            height: fieldHeight,
            child: TextFormField(
              controller: _currentPinController,
              decoration: InputDecoration(
                labelText: 'Current PIN',
                labelStyle: TextStyle(fontSize: fontSize, color: Colors.grey[700]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isCurrentPinVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[600],
                    size: fontSize,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCurrentPinVisible = !_isCurrentPinVisible;
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.number,
              obscureText: !_isCurrentPinVisible,
              style: TextStyle(fontSize: fontSize),
            ),
          ),

          SizedBox(height: 10),

          // New PIN
          SizedBox(
            height: fieldHeight,
            child: TextFormField(
              controller: _newPinController,
              decoration: InputDecoration(
                labelText: 'New PIN',
                labelStyle: TextStyle(fontSize: fontSize, color: Colors.grey[700]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPinVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[600],
                    size: fontSize,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPinVisible = !_isNewPinVisible;
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.number,
              obscureText: !_isNewPinVisible,
              style: TextStyle(fontSize: fontSize),
            ),
          ),

           SizedBox(height: 10),

          // Confirm PIN
          SizedBox(
            height: fieldHeight,
            child: TextFormField(
              controller: _confirmPinController,
              decoration: InputDecoration(
                labelText: 'Confirm New PIN',
                labelStyle: TextStyle(fontSize: fontSize, color: Colors.grey[700]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPinVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[600],
                    size: fontSize,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPinVisible = !_isConfirmPinVisible;
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.number,
              obscureText: !_isConfirmPinVisible,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePin() async {
    final response = await context.read<PinProvider>().updatePin(
      currentPin: _currentPinController.text,
      newPin: _newPinController.text,
      confirmPin: _confirmPinController.text,
    );

    if (response.isSuccess) {
      // Clear fields on success
      _currentPinController.clear();
      _newPinController.clear();
      _confirmPinController.clear();

      // Reset visibility states
      setState(() {
        _isCurrentPinVisible = false;
        _isNewPinVisible = false;
        _isConfirmPinVisible = false;
      });

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.message,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.message,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    // Reset provider state when screen is disposed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PinProvider>().resetState();
    });
    super.dispose();
  }
}