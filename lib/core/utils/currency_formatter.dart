import 'package:intl/intl.dart';

/// Formats monetary amounts in a locale-aware way.
///
/// * English locale → "EGP 50,000"
/// * Arabic locale  → "٥٠٬٠٠٠ ج.م"
class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount, {String localeCode = 'en'}) {
    if (localeCode == 'ar') {
      final fmt = NumberFormat('#,###', 'ar');
      return '${fmt.format(amount)} ج.م';
    }
    final fmt = NumberFormat('#,###', 'en');
    return 'EGP ${fmt.format(amount)}';
  }
}
