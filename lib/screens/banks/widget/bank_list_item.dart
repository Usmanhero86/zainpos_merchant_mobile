import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/services/models/response_model/bank_list_model.dart';

class BankListItem extends StatelessWidget {
  final Bank bank;
  final int successRate;
  final double ringSize;
  final double fontSize;
  final double spacing;
  final VoidCallback? onTap;

  const BankListItem({
    super.key,
    required this.bank,
    required this.successRate,
    required this.ringSize,
    required this.fontSize,
    required this.spacing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            _buildSuccessRing(),
            SizedBox(width: spacing),
            Expanded(child: _buildBankName()),
            Icon(Icons.chevron_right,
                color: Colors.grey.shade400,
                size: fontSize * 1.2),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessRing() {
    final color = _getSuccessColor(successRate);
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: ringSize,
          height: ringSize,
          child: CircularProgressIndicator(
            value: successRate / 100,
            strokeWidth: 3,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        Text(
          '$successRate%',
          style: TextStyle(
            fontSize: fontSize * 0.7,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBankName() {
    return Text(
      bank.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade800,
      ),
    );
  }

  Color _getSuccessColor(int rate) {
    if (rate >= 90) return Colors.green;
    if (rate >= 80) return Colors.blue;
    if (rate >= 70) return Colors.orange;
    return Colors.red;
  }
}
