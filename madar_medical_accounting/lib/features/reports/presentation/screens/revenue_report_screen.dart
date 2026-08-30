import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../revenue/data/models/revenue_transaction_model.dart';
import '../../../revenue/domain/repositories/revenue_repository.dart';
import '../../../revenue/presentation/providers/revenue_providers.dart';
import '../../data/export/report_table.dart';
import '../providers/report_providers.dart';
import '../widgets/export_button_row.dart';
import '../widgets/report_period_bar.dart';

const _reportId = 'revenue_report';

final _revenueReportDataProvider =
    FutureProvider.autoDispose<List<RevenueTransactionModel>>((ref) async {
  final range = ref.watch(reportPeriodProvider(_reportId));
  final repo = ref.watch(revenueRepositoryProvider);
  return repo.getAll(RevenueFilter(dateRange: range));
});

class RevenueReportScreen extends ConsumerWidget {
  const RevenueReportScreen({super.key});

  ReportTable _toTable(AppLocalizations l10n, List<RevenueTransactionModel> rows) {
    return ReportTable(
      title: l10n.reportRevenue,
      columns: [
        ReportColumn(l10n.date),
        const ReportColumn('Transaction No.'),
        ReportColumn(l10n.patientCustomer),
        ReportColumn(l10n.doctor),
        ReportColumn(l10n.service),
        ReportColumn(l10n.paymentMethod),
        ReportColumn(l10n.grossAmount, isNumeric: true),
        ReportColumn(l10n.discount, isNumeric: true),
        ReportColumn(l10n.netRevenue, isNumeric: true),
      ],
      rows: rows
          .map((t) => <Object>[
                DateFormatter.toDisplay(t.date),
                t.transactionNo,
                t.patientName ?? l10n.walkInPatient,
                t.doctorName ?? '-',
                t.serviceName ?? '-',
                t.paymentMethodName ?? '-',
                t.grossAmount,
                t.discount,
                t.netAmount,
              ])
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dataAsync = ref.watch(_revenueReportDataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportRevenue)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: const ReportPeriodBar(reportId: _reportId),
          ),
          Expanded(
            child: dataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('${l10n.errorGeneric} ($e)')),
              data: (rows) {
                if (rows.isEmpty) {
                  return EmptyState(icon: Icons.payments_outlined, title: l10n.noDataForPeriod);
                }
                final totalGross = rows.fold<double>(0, (s, r) => s + r.grossAmount);
                final totalDiscount = rows.fold<double>(0, (s, r) => s + r.discount);
                final totalNet = rows.fold<double>(0, (s, r) => s + r.netAmount);
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text(l10n.date)),
                            DataColumn(label: Text(l10n.patientCustomer)),
                            DataColumn(label: Text(l10n.doctor)),
                            DataColumn(label: Text(l10n.service)),
                            DataColumn(label: Text(l10n.paymentMethod)),
                            DataColumn(label: Text(l10n.grossAmount), numeric: true),
                            DataColumn(label: Text(l10n.discount), numeric: true),
                            DataColumn(label: Text(l10n.netRevenue), numeric: true),
                          ],
                          rows: rows
                              .map((t) => DataRow(cells: [
                                    DataCell(Text(DateFormatter.toDisplay(t.date))),
                                    DataCell(Text(t.patientName ?? l10n.walkInPatient)),
                                    DataCell(Text(t.doctorName ?? '-')),
                                    DataCell(Text(t.serviceName ?? '-')),
                                    DataCell(Text(t.paymentMethodName ?? '-')),
                                    DataCell(Text(CurrencyFormatter.formatNumber(t.grossAmount))),
                                    DataCell(Text(CurrencyFormatter.formatNumber(t.discount))),
                                    DataCell(Text(CurrencyFormatter.formatNumber(t.netAmount))),
                                  ]))
                              .toList(),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${rows.length} ${l10n.transactionCount.toLowerCase()}', style: const TextStyle(fontSize: 12)),
                          Text(
                            '${l10n.grossAmount} ${CurrencyFormatter.format(totalGross)}  ·  ${l10n.discount} ${CurrencyFormatter.format(totalDiscount)}  ·  ${l10n.netRevenue} ${CurrencyFormatter.format(totalNet)}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ExportButtonRow(buildTable: () => _toTable(l10n, rows)),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
