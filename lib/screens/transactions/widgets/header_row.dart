// import 'package:flutter/material.dart';
//
// Widget HeaderRow(ThemeData theme, double scale) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Flexible(
//         child: Row(
//           children: [
//             // Status indicator dot
//             Container(
//               width: scale * 0.6,
//               height: scale * 0.6,
//               decoration: BoxDecoration(
//                 color: _getStatusColor(status),
//                 shape: BoxShape.circle,
//               ),
//             ),
//             SizedBox(width: scale * 0.4),
//             Flexible(
//               child: Text(
//                 '${status.toUpperCase()} - ${_shortenReference(reference)}',
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                   color: _getStatusColor(status),
//                 ),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//               ),
//             ),
//           ],
//         ),
//       ),
//       if (amount > 0)
//         Text(
//           _formatCurrency(amount),
//           style: theme.textTheme.titleSmall?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: _getAmountColor(),
//           ),
//         ),
//     ],
//   );
// }
// Color _getStatusColor(String status) {
//   switch (status.toLowerCase()) {
//     case 'success':
//     case 'completed':
//       return Colors.green;
//     case 'pending':
//     case 'processing':
//       return Colors.orange;
//     case 'failed':
//     case 'declined':
//       return Colors.red;
//     default:
//       return Colors.grey;
//   }
// }
// Color _getAmountColor() {
//   switch (status.toLowerCase()) {
//     case 'success':
//     case 'completed':
//       return Colors.green.shade700;
//     case 'failed':
//     case 'declined':
//       return Colors.red.shade700;
//     default:
//       return Colors.black;
//   }
// }
// String _shortenReference(String ref) {
//   if (ref.length <= 12) return ref;
//   return '${ref.substring(0, 8)}...${ref.substring(ref.length - 4)}';
// }
