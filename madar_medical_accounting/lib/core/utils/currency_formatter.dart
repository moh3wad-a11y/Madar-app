import 'package:intl/intl.dart';

/// Formats amounts as "1,250.00 EGP" using Western digits, which is the
/// standard convention for financial apps in Egypt even inside Arabic UI.
/// If Arabic-Indic numerals are ever required, swap the locale below to
/// 'ar' and this is the only file that needs to change.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
    decimalDigits: 2,
  );

  static String format(double amount, {String currencyCode = 'EGP'}) {
    return '${_formatter.format(amount).trim()} $currencyCode';
  }

  static String formatNumber(double amount) => _formatter.format(amount).trim();

  static double? parse(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9.\-]'), '');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }
}
