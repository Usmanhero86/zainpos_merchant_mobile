import 'package:flutter/material.dart';
import '../../settings/settings_screen.dart';

void showSettingsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SettingsScreen(
      initialTransfersEnabled: true,
      initialBalanceEnabled: true,
      initialReprintEnabled: false,
      onSettingsApplied: (settings) {
        // handle settings
      },
    ),
  );
}
