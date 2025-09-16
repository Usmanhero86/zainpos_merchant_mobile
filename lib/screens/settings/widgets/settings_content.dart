import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/settings/widgets/setting_item.dart';

class SettingsContent extends StatefulWidget {
  final bool initialTransfersEnabled;
  final bool initialBalanceEnabled;
  final bool initialReprintEnabled;
  final Function(Map<String, bool>)? onSettingsApplied;

  const SettingsContent({
    super.key,
    required this.initialTransfersEnabled,
    required this.initialBalanceEnabled,
    required this.initialReprintEnabled,
    this.onSettingsApplied,
  });

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  late bool _transfersEnabled;
  late bool _balanceEnabled;
  late bool _reprintEnabled;

  @override
  void initState() {
    super.initState();
    _transfersEnabled = widget.initialTransfersEnabled;
    _balanceEnabled = widget.initialBalanceEnabled;
    _reprintEnabled = widget.initialReprintEnabled;
  }

  void applySettings() {
    final Map<String, bool> settings = {
      'transfers': _transfersEnabled,
      'balance': _balanceEnabled,
      'reprint': _reprintEnabled,
    };
    widget.onSettingsApplied?.call(settings);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings applied: $settings'),
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: w * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: h * 0.012),

          SettingItem(
            title: 'Transfers',
            description: 'Enable/disable transfer on terminal',
            value: _transfersEnabled,
            onChanged: (v) => setState(() => _transfersEnabled = v),
          ),
          SizedBox(height: h * 0.012),

          SettingItem(
            title: 'Balance',
            description: 'Enable/disable view balance on terminal',
            value: _balanceEnabled,
            onChanged: (v) => setState(() => _balanceEnabled = v),
          ),
          SizedBox(height: h * 0.012),

          SettingItem(
            title: 'Reprint',
            description: 'Enable/disable reprint on terminal',
            value: _reprintEnabled,
            onChanged: (v) => setState(() => _reprintEnabled = v),
          ),

          SizedBox(height: h * 0.02),
          const Divider(),
          SizedBox(height: h * 0.02),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: applySettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: h * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w * 0.05),
                ),
              ),
              child: Text(
                'Apply',
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}