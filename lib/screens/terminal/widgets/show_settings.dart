import 'package:flutter/material.dart';
import '../../settings/settings_screen.dart';

void showSettingsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // keeps rounded corners visible
    builder: (_) {
      return FractionallySizedBox(
        heightFactor: 1 / 2,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SettingsScreen(
            initialTransfersEnabled: true,
            initialBalanceEnabled: true,
            initialReprintEnabled: false,
            onSettingsApplied: (settings) {
              // handle settings
            },
          ),
        ),
      );
    },
  );
}
