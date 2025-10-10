class CurrencyFormatter {
  static String getAmountWithCurrency(dynamic amount, {String currencySymbol = '₦'}) {
    if (amount == null) return '$currencySymbol 0.00';

    double value;

    if (amount is int) {
      value = amount.toDouble();
    } else if (amount is double) {
      value = amount;
    } else if (amount is String) {
      // Remove any existing currency symbols and commas
      final cleaned = amount.replaceAll(RegExp(r'[^\d.]'), '');
      value = double.tryParse(cleaned) ?? 0.0;
    } else {
      value = 0.0;
    }

    // Format with commas for thousands and 2 decimal places
    final formatted = value.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );

    return '$currencySymbol$formatted';
  }

  static String formatAmount(double amount, {String currencySymbol = '₦'}) {
    return getAmountWithCurrency(amount, currencySymbol: currencySymbol);
  }
}