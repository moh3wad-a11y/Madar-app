import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/export/report_table.dart';
import '../../domain/report_aggregation_service.dart';
import '../providers/report_providers.dart';
import '../widgets/export_button_row.dart';

final _selectedDayProvider = StateProvider.autoDispose<DateTime>((ref) => DateTime.now());

final _dailyClosingDataProvider = FutureProvider.autoDispose<DailyClosingReport>((ref) async {
  final day = ref.watch(_selectedDayProvider);
  final service = ref.watch(reportAggregationServiceProvider);
  return service.getDailyClosing(day);
});

class DailyClosingReportScreen extends ConsumerWidget {
  const DailyClosingReportScreen({super.key});

  ReportTable _toTable(AppLocalizations l10n, DailyClosingReport report) {
    return ReportTable(
      title: l10n.reportDailyClosing,
      columns: [
        ReportColumn(l10n.description),
        ReportColumn(l10n.amount, isNumeric: true),
      ],
      rows: [
        <Object>[l10n.date, DateFormatter.toDisplay(report.date)],
        <Object>[l10n.openingCash, report.openingCash],
        <Object>[l10n.cashRevenue, report.cashRevenue],
        <Object>[l10n.cashExpenses, -report.cashExpenses],
        <Object>[l10n.closingCash, report.closingCash],
      ],
      includeTotalsRow: false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDay = ref.watch(_selectedDayProvider);
    final dataAsync = ref.watch(_dailyClosingDataProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportDailyClosing)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDay,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) ref.read(_selectedDayProvider.notifier).state = picked;
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.closingDate,
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                suffixIcon: const Icon(Icons.chevron_right),
              ),
              child: Text(DateFormatter.toDisplay(selectedDay)),
            ),
          ),
          const SizedBox(height: 20),
          dataAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(padding: const EdgeInsets.all(24), child: Text('${l10n.errorGeneric} ($e)')),
            data: (report) => Column(
              children: [
                _Row(l10n.openingCash, report.openingCash, theme),
                _Row('+ ${l10n.cashRevenue}', report.cashRevenue, theme, color: AppTheme.revenueColor),
                _Row('- ${l10n.cashExpenses}', report.cashExpenses, theme, color: AppTheme.expenseColor),
                const Divider(thickness: 1.5),
                _Row('= ${l10n.closingCash}', report.closingCash, theme, bold: true),
                const SizedBox(height: 24),
                ExportButtonRow(buildTable: () => _toTable(l10n, report)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final double value;
  final ThemeData theme;
  final Color? color;
  final bool bold;

  const _Row(this.label, this.value, this.theme, {this.color, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: bold ? 10 : 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400, fontSize: bold ? 16 : 14),
          ),
          Text(
            CurrencyFormatter.format(value),
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              fontSize: bold ? 16 : 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
