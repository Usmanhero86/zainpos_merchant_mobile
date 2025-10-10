import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/dispute/dispute_resolved.dart';
import 'package:zainpos_merchant_mobile/screens/transactions/failed_transaction_screen.dart';
import '../../../services/models/response_model/dispute_list_response.dart';

class DisputeItem extends StatelessWidget {
  const DisputeItem({super.key, required this.dispute});
  final DisputeModel dispute;

  // Helper method to get color based on status
  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'RESOLVED':
        return Colors.green;
      case 'OPEN':
        return Colors.blue;
      case 'REFUNDED':
        return Colors.brown;
      case 'PENDING':
        return Colors.orange;
      case 'FAILED':
        return Colors.red;
      default:
        return Colors.grey; // Default color for unknown status
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            if (dispute.status.toUpperCase() == 'RESOLVED') {
              return DisputeResolved(dispute: dispute);
            } else {
              return FailedTransactionScreen(dispute: dispute);
            }
          }),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'TRN-REF: ${dispute.txnRrn}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Text(
                  '₦${dispute.txnAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        if (dispute.status.toUpperCase() == 'RESOLVED') {
                          return DisputeResolved(dispute: dispute);
                        } else {
                          return FailedTransactionScreen(dispute: dispute);
                        }
                      }),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios, size: 14),
                ),
              ],
            ),
            Text(
              dispute.terminalId,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  dispute.status.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(dispute.status),
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  dispute.txnDate.toString().split(' ').first,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}