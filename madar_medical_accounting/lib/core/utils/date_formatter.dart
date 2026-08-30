import 'package:intl/intl.dart';

/// Handles the split between how dates are STORED (yyyy-MM-dd, so SQLite
/// can sort/filter them lexicographically) and how they are DISPLAYED
/// (dd/MM/yyyy, per the Egyptian format requirement).
class DateFormatter {
  DateFormatter._();

  static final DateFormat _displayFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _storageFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _displayDateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

  static String toDisplay(DateTime date) => _displayFormat.format(date);

  static String toDisplayDateTime(DateTime date) => _displayDateTimeFormat.format(date);

  static String toStorage(DateTime date) => _storageFormat.format(date);

  static DateTime fromStorage(String stored) => _storageFormat.parse(stored);

  static String currentTime() => _timeFormat.format(DateTime.now());

  static DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  static DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month, 1);

  static DateTime endOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);

  static DateTime startOfWeek(DateTime date) {
    final daysFromSaturday = (date.weekday % 7); // Egypt: week starts Saturday
    return startOfDay(date.subtract(Duration(days: daysFromSaturday)));
  }
}

enum DateRangePreset { today, yesterday, thisWeek, thisMonth, lastMonth, thisYear, custom }

class DateRange {
  final DateTime start;
  final DateTime end;
  final DateRangePreset preset;

  const DateRange({required this.start, required this.end, required this.preset});

  factory DateRange.fromPreset(DateRangePreset preset, {DateTime? customStart, DateTime? customEnd}) {
    final now = DateTime.now();
    switch (preset) {
      case DateRangePreset.today:
        return DateRange(
          start: DateFormatter.startOfDay(now),
          end: DateFormatter.endOfDay(now),
          preset: preset,
        );
      case DateRangePreset.yesterday:
        final yesterday = now.subtract(const Duration(days: 1));
        return DateRange(
          start: DateFormatter.startOfDay(yesterday),
          end: DateFormatter.endOfDay(yesterday),
          preset: preset,
        );
      case DateRangePreset.thisWeek:
        return DateRange(
          start: DateFormatter.startOfWeek(now),
          end: DateFormatter.endOfDay(now),
          preset: preset,
        );
      case DateRangePreset.thisMonth:
        return DateRange(
          start: DateFormatter.startOfMonth(now),
          end: DateFormatter.endOfDay(now),
          preset: preset,
        );
      case DateRangePreset.lastMonth:
        final lastMonthDate = DateTime(now.year, now.month - 1, 1);
        return DateRange(
          start: DateFormatter.startOfMonth(lastMonthDate),
          end: DateFormatter.endOfMonth(lastMonthDate),
          preset: preset,
        );
      case DateRangePreset.thisYear:
        return DateRange(
          start: DateTime(now.year, 1, 1),
          end: DateFormatter.endOfDay(now),
          preset: preset,
        );
      case DateRangePreset.custom:
        return DateRange(
          start: DateFormatter.startOfDay(customStart ?? now),
          end: DateFormatter.endOfDay(customEnd ?? now),
          preset: preset,
        );
    }
  }
}
