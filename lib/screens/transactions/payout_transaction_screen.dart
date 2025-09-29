import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/provider/payout_provider.dart';

class PayoutTransactionsScreen extends StatefulWidget {
  const PayoutTransactionsScreen({super.key});

  @override
  State<PayoutTransactionsScreen> createState() =>
      _PayoutTransactionsScreenState();
}

class _PayoutTransactionsScreenState extends State<PayoutTransactionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PayoutProvider>().loadPayoutHistory());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth * 0.04; // base scale factor
    final textTheme = Theme.of(context).textTheme;

    return Consumer<PayoutProvider>(
      builder: (context, provider, _) {
        final payouts = provider.payoutResponse?.data ?? [];
        if (provider.isLoading && payouts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null && payouts.isEmpty) {
          return Center(child: Text('Error: ${provider.error}'));
        }
        if (payouts.isEmpty) {
          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: scale * 10),
                Center(
                  child: Text(
                    'No payout history',
                    style: textTheme.bodyMedium?.copyWith(fontSize: scale),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: provider.refresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(scale * 0.8),
            itemCount: payouts.length,
            itemBuilder: (context, index) {
              final p = payouts[index];
              final amount = double.tryParse(p.amount) ?? 0;
              final formattedDate =
                  '${p.txnDate.year}-${p.txnDate.month.toString().padLeft(2, '0')}-${p.txnDate.day.toString().padLeft(2, '0')} '
                  '${TimeOfDay.fromDateTime(p.txnDate).format(context)}';

              return Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: scale * 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(scale * 0.7),
                ),
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(scale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Reference & Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              p.txnRef,
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: scale * 0.8,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '₦${_formatAmount(amount.toStringAsFixed(2))}',
                            style: textTheme.titleMedium?.copyWith(
                              fontSize: scale * 1.1,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: scale * 0.1),

                      /// Terminal Name
                      Text(
                        p.terminalName,
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: scale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: scale * 0.2),

                      /// Zainpay ref and Date
                      Text(
                        '${p.zainpayPaymentRef.isNotEmpty ? p.zainpayPaymentRef : p.txnRef}\n$formattedDate',
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: scale * 0.8,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
String _formatAmount(dynamic raw) {
  // Accepts int, double, or String
  double value;

  if (raw is int) {
    value = raw / 100;
  } else if (raw is double) {
    value = raw / 100;
  } else if (raw is String) {
    // Remove commas or symbols if present, then parse
    final cleaned = raw.replaceAll(RegExp(r'[^\d.]'), '');
    value = double.tryParse(cleaned) != null
        ? (double.parse(cleaned) / 100)
        : 0.0;
  } else {
    value = 0.0;
  }

  // Show two decimal places
  return value.toStringAsFixed(2);
}
