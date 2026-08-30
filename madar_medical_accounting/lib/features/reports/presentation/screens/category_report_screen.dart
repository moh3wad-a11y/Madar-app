import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../data/export/report_table.dart';
import '../../domain/report_aggregation_service.dart';
import '../providers/report_providers.dart';
import '../widgets/export_button_row.dart';
import '../widgets/report_period_bar.dart';

const _reportId = 'category_report';

final _categoryReportDataProvider = FutureProvider.autoDispose<List<CategoryReportRow>>((ref) async {
  final range = ref.watch(reportPeriodProvider(_reportId));
  final service = ref.watch(reportAggregationServiceProvider);
  return service.getCategoryReport(range);
});

class CategoryReportScreen extends ConsumerWidget {
  const CategoryReportScreen({super.key});

  ReportTable _toTable(AppLocalizations l10n, List<CategoryReportRow> rows) {
    return ReportTable(
      title: l10n.reportCategory,
      columns: [
        ReportColumn(l10n.expenseCategory),
        ReportColumn(l10n.transactionCount, isNumeric: true),
        ReportColumn(l10n.total, isNumeric: true),
      ],
      rows: rows.map((r) => <Object>[r.categoryName, r.transactionCount, r.total]).toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dataAsync = ref.watch(_categoryReportDataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportCategory)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ReportPeriodBar(reportId: _reportId),
          const SizedBox(height: 16),
          dataAsync.when(
            loading: () =>
                const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())),
            error: (e, _) => Padding(padding: const EdgeInsets.all(24), child: Text('${l10n.errorGeneric} ($e)')),
            data: (rows) {
              if (rows.isEmpty) {
                return EmptyState(icon: Icons.category_outlined, title: l10n.noDataFound);
              }
              return Column(
                children: [
                  Card(
                    child: Column(
                      children: rows
                          .map((r) => ListTile(
                                title: Text(r.categoryName),
                                subtitle: Text('${r.transactionCount} ${l10n.transactionCount.toLowerCase()}'),
                                trailing: Text(
                                  CurrencyFormatter.format(r.total),
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ExportButtonRow(buildTable: () => _toTable(l10n, rows)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
