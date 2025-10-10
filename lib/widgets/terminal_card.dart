import 'package:flutter/material.dart';
import '../screens/terminal/nassarawa_terminal.dart';
import '../services/models/response_model/terminal_response.dart';

class TerminalCard extends StatelessWidget {
  final Terminals terminal;

  const TerminalCard({super.key, required this.terminal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.white,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NassarawaTerminalScreen(terminal: terminal),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: (terminal.isActive ?? false)
                        ? Colors.green
                        : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    (terminal.isActive ?? false) ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: (terminal.isActive ?? false)
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
                Text(
                  terminal.terminalId ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),

            const SizedBox(height: 8),
            Text(
              terminal.terminalName ?? 'Unknown Terminal',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'ID: ${terminal.id ?? "N/A"}',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),

            // Add more terminal information
            if (terminal.virtualAccountNumber != null)
              Text(
                'Account: ${terminal.virtualAccountNumber!}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}