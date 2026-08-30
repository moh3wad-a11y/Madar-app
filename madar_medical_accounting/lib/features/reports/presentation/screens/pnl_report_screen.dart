import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/export/report_table.dart';
import '../../domain/report_aggregation_service.dart';
import '../providers/report_providers.dart';
import '../widgets/export_button_row.dart';
import '../widgets/report_period_bar.dart';

const _reportId = 'pnl';

final _pnlDataProvider = FutureProvider.autoDispose<PnLReport>((ref) async {
  final range = ref.watch(reportPeriodProvider(_reportId));
  final service = ref.watch(reportAggregationServiceProvider);
  return service.getPnL(range);
});

class PnlReportScreen extends ConsumerWidget {
  const PnlReportScreen({super.key});

  ReportTable _toTable(AppLocalizations l10n, PnLReport report) {
    return ReportTable(
      title: l10n.reportPnl,
      columns: [
        ReportColumn(l10n.description),
        ReportColumn(l10n.amount, isNumeric: true),
      ],
      rows: [
        [l10n.grossRevenue, report.grossRevenue],
        [l10n.discounts, -report.discounts],
        [l10n.netRevenue, report.netRevenue],
        [l10n.doctorCommissions, -report.doctorCommissions],
        [l10n.grossProfit, report.grossProfit],
        [l10n.operatingExpenses, -report.operatingExpenses],
        [l10n.netProfit, report.netProfit],
      ],
      includeTotalsRow: false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dataAsync = ref.watch(_pnlDataProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportPnl)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ReportPeriodBar(reportId: _reportId),
          const SizedBox(height: 16),
          dataAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(padding: const EdgeInsets.all(24), child: Text('${l10n.errorGeneric} ($e)')),
            data: (report) => Column(
              children: [
                _PnLLine(label: l10n.grossRevenue, value: report.grossRevenue),
                _PnLLine(label: l10n.discounts, value: -report.discounts, isDeduction: true),
                const Divider(),
                _PnLLine(label: l10n.netRevenue, value: report.netRevenue, isSubtotal: true),
                _PnLLine(label: l10n.doctorCommissions, value: -report.doctorCommissions, isDeduction: true),
                const Divider(),
                _PnLLine(
                  label: l10n.grossProfit,
                  value: report.grossProfit,
                  isSubtotal: true,
                  color: AppTheme.profitColor,
                ),
                _PnLLine(label: l10n.operatingExpenses, value: -report.operatingExpenses, isDeduction: true),
                const Divider(thickness: 1.5),
                _PnLLine(
                  label: l10n.netProfit,
                  value: report.netProfit,
                  isSubtotal: true,
                  isFinal: true,
                  color: report.netProfit >= 0 ? AppTheme.revenueColor : theme.colorScheme.error,
                ),
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

class _PnLLine extends StatelessWidget {
  final String label;
  final double value;
  final bool isSubtotal;
  final bool isDeduction;
  final bool isFinal;
  final Color? color;

  const _PnLLine({
    required this.label,
    required this.value,
    this.isSubtotal = false,
    this.isDeduction = false,
    this.isFinal = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isFinal ? 10 : 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isSubtotal ? FontWeight.w700 : FontWeight.w400,
              fontSize: isFinal ? 16 : 14,
              color: isDeduction ? theme.colorScheme.outline : null,
            ),
          ),
          Text(
            '${isDeduction && value < 0 ? '-' : ''}${CurrencyFormatter.format(value.abs())}',
            style: TextStyle(
              fontWeight: isSubtotal ? FontWeight.w700 : FontWeight.w500,
              fontSize: isFinal ? 16 : 14,
              color: color ?? (isDeduction ? theme.colorScheme.outline : null),
            ),
          ),
        ],
      ),
    );
  }
}
