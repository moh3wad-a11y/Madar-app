import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../expenses/data/models/expense_transaction_model.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../../../expenses/presentation/providers/expense_providers.dart';
import '../../data/export/report_table.dart';
import '../providers/report_providers.dart';
import '../widgets/export_button_row.dart';
import '../widgets/report_period_bar.dart';

const _reportId = 'expense_report';

final _expenseReportDataProvider =
    FutureProvider.autoDispose<List<ExpenseTransactionModel>>((ref) async {
  final range = ref.watch(reportPeriodProvider(_reportId));
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.getAll(ExpenseFilter(dateRange: range));
});

class ExpenseReportScreen extends ConsumerWidget {
  const ExpenseReportScreen({super.key});

  ReportTable _toTable(AppLocalizations l10n, List<ExpenseTransactionModel> rows) {
    return ReportTable(
      title: l10n.reportExpense,
      columns: [
        ReportColumn(l10n.date),
        const ReportColumn('Expense No.'),
        ReportColumn(l10n.expenseCategory),
        ReportColumn(l10n.supplierOptional),
        ReportColumn(l10n.description),
        ReportColumn(l10n.paymentMethod),
        ReportColumn(l10n.amount, isNumeric: true),
      ],
      rows: rows
          .map((e) => <Object>[
                DateFormatter.toDisplay(e.date),
                e.expenseNo,
                e.categoryName ?? '-',
                e.supplierName ?? '-',
                e.description ?? '-',
                e.paymentMethodName ?? '-',
                e.amount,
              ])
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dataAsync = ref.watch(_expenseReportDataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportExpense)),
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
                  return EmptyState(icon: Icons.receipt_long_outlined, title: l10n.noDataForPeriod);
                }
                final total = rows.fold<double>(0, (s, r) => s + r.amount);
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text(l10n.date)),
                            DataColumn(label: Text(l10n.expenseCategory)),
                            DataColumn(label: Text(l10n.supplierOptional)),
                            DataColumn(label: Text(l10n.description)),
                            DataColumn(label: Text(l10n.paymentMethod)),
                            DataColumn(label: Text(l10n.amount), numeric: true),
                          ],
                          rows: rows
                              .map((e) => DataRow(cells: [
                                    DataCell(Text(DateFormatter.toDisplay(e.date))),
                                    DataCell(Text(e.categoryName ?? '-')),
                                    DataCell(Text(e.supplierName ?? '-')),
                                    DataCell(Text(e.description ?? '-')),
                                    DataCell(Text(e.paymentMethodName ?? '-')),
                                    DataCell(Text(CurrencyFormatter.formatNumber(e.amount))),
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
                            '${l10n.total} ${CurrencyFormatter.format(total)}',
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
