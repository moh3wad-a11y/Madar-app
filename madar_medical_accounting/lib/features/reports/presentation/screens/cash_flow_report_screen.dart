import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/export/report_table.dart';
import '../../domain/report_aggregation_service.dart';
import '../providers/report_providers.dart';
import '../widgets/export_button_row.dart';
import '../widgets/report_period_bar.dart';

const _reportId = 'cashflow';

final _cashFlowDataProvider = FutureProvider.autoDispose<List<AccountCashFlow>>((ref) async {
  final range = ref.watch(reportPeriodProvider(_reportId));
  final service = ref.watch(reportAggregationServiceProvider);
  return service.getCashFlow(range);
});

class CashFlowReportScreen extends ConsumerWidget {
  const CashFlowReportScreen({super.key});

  ReportTable _toTable(AppLocalizations l10n, List<AccountCashFlow> flows) {
    return ReportTable(
      title: l10n.reportCashFlow,
      columns: [
        ReportColumn(l10n.paymentAccountsTitle),
        ReportColumn(l10n.openingBalance, isNumeric: true),
        ReportColumn(l10n.cashInflows, isNumeric: true),
        ReportColumn(l10n.cashOutflows, isNumeric: true),
        ReportColumn(l10n.closingBalance, isNumeric: true),
      ],
      rows: flows
          .map((f) => <Object>[f.accountName, f.openingBalance, f.inflows, f.outflows, f.closingBalance])
          .toList(),
      includeTotalsRow: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dataAsync = ref.watch(_cashFlowDataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportCashFlow)),
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
            data: (flows) {
              final totalClosing = flows.fold<double>(0, (sum, f) => sum + f.closingBalance);
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.profitColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.totalClosingBalance, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          CurrencyFormatter.format(totalClosing),
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.profitColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...flows.map((flow) => _AccountFlowCard(flow: flow, l10n: l10n)),
                  const SizedBox(height: 8),
                  ExportButtonRow(buildTable: () => _toTable(l10n, flows)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AccountFlowCard extends StatelessWidget {
  final AccountCashFlow flow;
  final AppLocalizations l10n;

  const _AccountFlowCard({required this.flow, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(flow.accountName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 8),
            _Row(l10n.openingBalance, flow.openingBalance, theme),
            _Row('+ ${l10n.cashInflows}', flow.inflows, theme, color: AppTheme.revenueColor),
            _Row('- ${l10n.cashOutflows}', flow.outflows, theme, color: AppTheme.expenseColor),
            const Divider(),
            _Row('= ${l10n.closingBalance}', flow.closingBalance, theme, bold: true),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
          Text(
            CurrencyFormatter.format(value),
            style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}
