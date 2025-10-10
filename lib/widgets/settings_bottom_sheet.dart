import 'package:flutter/material.dart';
import '../services/models/response_model/home_response.dart';

class SettingsBottomSheet extends StatelessWidget {
  final Terminal terminal;

  const SettingsBottomSheet({super.key, required this.terminal});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Terminal Settings',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Terminal Information Section
          _buildSectionHeader('TERMINAL INFORMATION'),
          const SizedBox(height: 12),

          _buildInfoRow(
            icon: Icons.business,
            title: 'Business Name',
            value: terminal.businessName ?? 'Not available',
          ),
          _buildInfoRow(
            icon: Icons.credit_card,
            title: 'Terminal ID',
            value: terminal.id ?? 'Not available',
          ),
          _buildInfoRow(
            icon: Icons.account_balance,
            title: 'Virtual Account',
            value: terminal.virtualAccountNumber ?? 'Not available',
          ),
          _buildInfoRow(
            icon: Icons.location_on,
            title: 'Location',
            value: terminal.businessAddress ?? 'Not available',
          ),

          const SizedBox(height: 24),

          // Actions Section
          _buildSectionHeader('ACTIONS'),
          const SizedBox(height: 12),

          _buildActionTile(
            icon: Icons.refresh,
            title: 'Refresh Balance',
            onTap: () {
              Navigator.pop(context);
              // Trigger balance refresh in parent
            },
          ),
          _buildActionTile(
            icon: Icons.receipt_long,
            title: 'View Full Statement',
            onTap: () {
              Navigator.pop(context);
              // Navigate to full statement
            },
          ),
          _buildActionTile(
            icon: Icons.download,
            title: 'Download Transactions',
            onTap: () {
              Navigator.pop(context);
              // Trigger download
            },
          ),
          _buildActionTile(
            icon: Icons.qr_code,
            title: 'Show QR Code',
            onTap: () {
              Navigator.pop(context);
              // Show QR code
            },
          ),

          const SizedBox(height: 24),

          // Danger Zone
          _buildSectionHeader('DANGER ZONE'),
          const SizedBox(height: 12),

          _buildActionTile(
            icon: Icons.block,
            title: 'Deactivate Terminal',
            color: Colors.red,
            onTap: () {
              _showDeactivateDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showDeactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deactivate Terminal'),
          content: Text(
            'Are you sure you want to deactivate terminal ${terminal.id}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close bottom sheet
                _deactivateTerminal();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Deactivate'),
            ),
          ],
        );
      },
    );
  }

  void _deactivateTerminal() {
    // Implement terminal deactivation logic here
    // This would typically call an API endpoint
  }
}