/// Formats date-related strings in a locale-aware way.
///
/// Example:
/// * English → "37 days remaining"
/// * Arabic  → "متبقي ٣٧ يومًا"
class DateFormatter {
  DateFormatter._();

  /// Returns a human-readable countdown string for [deadline].
  static String daysRemaining(DateTime deadline, {String localeCode = 'en'}) {
    final now = DateTime.now();
    final days = deadline.difference(now).inDays;

    if (localeCode == 'ar') {
      return 'متبقي $days يومًا';
    }
    return '$days days remaining';
  }

  /// Returns a short date string (e.g. "Aug 10, 2025").
  static String shortDate(DateTime date, {String localeCode = 'en'}) {
    final months = localeCode == 'ar'
        ? [
            'يناير',
            'فبراير',
            'مارس',
            'أبريل',
            'مايو',
            'يونيو',
            'يوليو',
            'أغسطس',
            'سبتمبر',
            'أكتوبر',
            'نوفمبر',
            'ديسمبر',
          ]
        : [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
