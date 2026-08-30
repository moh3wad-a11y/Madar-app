import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/dashboard_summary_service.dart';

final dashboardSummaryServiceProvider = Provider<DashboardSummaryService>((ref) {
  return DashboardSummaryService();
});

final dashboardDateRangeProvider = StateProvider<DateRange>((ref) {
  return DateRange.fromPreset(DateRangePreset.thisMonth);
});

final dashboardSummaryProvider = FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final range = ref.watch(dashboardDateRangeProvider);
  final service = ref.watch(dashboardSummaryServiceProvider);
  return service.load(range);
});
