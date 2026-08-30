import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/report_aggregation_service.dart';

final reportAggregationServiceProvider = Provider<ReportAggregationService>((ref) {
  return ReportAggregationService();
});

/// Each report screen creates its own instance of this via a family
/// keyed on a string id (e.g. 'pnl', 'cashflow') so switching the date
/// range on one report never affects another - unlike the dashboard's
/// single shared filter, these are genuinely independent screens a user
/// might navigate between with different periods in mind.
final reportPeriodProvider =
    StateProvider.autoDispose.family<DateRange, String>((ref, reportId) {
  return DateRange.fromPreset(DateRangePreset.thisMonth);
});
