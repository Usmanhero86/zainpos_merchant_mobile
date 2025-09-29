import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/settings/widgets/settings_content.dart';

class SettingsScreen extends StatelessWidget {
  final bool initialTransfersEnabled;
  final bool initialBalanceEnabled;
  final bool initialReprintEnabled;
  final Function(Map<String, bool>)? onSettingsApplied;

  const SettingsScreen({
    super.key,
    this.initialTransfersEnabled = true,
    this.initialBalanceEnabled = true,
    this.initialReprintEnabled = false,
    this.onSettingsApplied,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Container(
      height: h * 0.4,
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: w * 0.1,
            height: h * 0.002,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(h * 0.003),
            ),
          ),
          SizedBox(height: h * 0.003),
          Expanded(
            child: SettingsContent(
              initialTransfersEnabled: initialTransfersEnabled,
              initialBalanceEnabled: initialBalanceEnabled,
              initialReprintEnabled: initialReprintEnabled,
              onSettingsApplied: onSettingsApplied,
            ),
          ),
        ],
      ),
    );
  }
}


