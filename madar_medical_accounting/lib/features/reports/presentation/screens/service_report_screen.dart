import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../data/export/report_table.dart';
import '../../domain/report_aggregation_service.dart';
import '../providers/report_providers.dart';
import '../widgets/export_button_row.dart';
import '../widgets/report_period_bar.dart';

const _reportId = 'service_report';

final _serviceReportDataProvider = FutureProvider.autoDispose<List<ServiceReportRow>>((ref) async {
  final range = ref.watch(reportPeriodProvider(_reportId));
  final service = ref.watch(reportAggregationServiceProvider);
  return service.getServiceReport(range);
});

class ServiceReportScreen extends ConsumerWidget {
  const ServiceReportScreen({super.key});

  ReportTable _toTable(AppLocalizations l10n, List<ServiceReportRow> rows) {
    return ReportTable(
      title: l10n.reportService,
      columns: [
        ReportColumn(l10n.service),
        ReportColumn(l10n.transactionCount, isNumeric: true),
        ReportColumn(l10n.monthlyRevenue, isNumeric: true),
      ],
      rows: rows.map((r) => <Object>[r.serviceName, r.transactionCount, r.revenue]).toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dataAsync = ref.watch(_serviceReportDataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportService)),
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
                return EmptyState(icon: Icons.medical_information_outlined, title: l10n.noDataFound);
              }
              return Column(
                children: [
                  Card(
                    child: Column(
                      children: rows
                          .map((r) => ListTile(
                                title: Text(r.serviceName),
                                subtitle: Text('${r.transactionCount} ${l10n.transactionCount.toLowerCase()}'),
                                trailing: Text(
                                  CurrencyFormatter.format(r.revenue),
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
