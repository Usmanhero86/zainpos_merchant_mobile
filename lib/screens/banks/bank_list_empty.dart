import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/services/models/response_model/bank_list_model.dart';

class BankListEmpty extends StatelessWidget {
  final Bank bank;
  final VoidCallback? onTap;

  const BankListEmpty({
    super.key,
    required this.bank,
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
            Expanded(child: _buildBankName()),
          ],
        ),
      ),
    );
  }


  Widget _buildBankName() {
    return Text(
      bank.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade800,
      ),
    );
  }

}
