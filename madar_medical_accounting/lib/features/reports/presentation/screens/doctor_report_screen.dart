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

const _reportId = 'doctor_report';

final _doctorReportDataProvider = FutureProvider.autoDispose<List<DoctorReportRow>>((ref) async {
  final range = ref.watch(reportPeriodProvider(_reportId));
  final service = ref.watch(reportAggregationServiceProvider);
  return service.getDoctorReport(range);
});

class DoctorReportScreen extends ConsumerWidget {
  const DoctorReportScreen({super.key});

  ReportTable _toTable(AppLocalizations l10n, List<DoctorReportRow> rows) {
    return ReportTable(
      title: l10n.reportDoctor,
      columns: [
        ReportColumn(l10n.doctor),
        ReportColumn(l10n.revenueGenerated, isNumeric: true),
        ReportColumn(l10n.commission, isNumeric: true),
        ReportColumn(l10n.centerShare, isNumeric: true),
      ],
      rows: rows.map((r) => <Object>[r.doctorName, r.revenue, r.commission, r.centerShare]).toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dataAsync = ref.watch(_doctorReportDataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportDoctor)),
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
                return EmptyState(icon: Icons.medical_services_outlined, title: l10n.noDataFound);
              }
              return Column(
                children: [
                  ...rows.map((r) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.doctorName, style: const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              _StatLine(l10n.revenueGenerated, r.revenue),
                              _StatLine(l10n.commission, r.commission),
                              _StatLine(l10n.centerShare, r.centerShare, bold: true),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 8),
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

class _StatLine extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;

  const _StatLine(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 13)),
          Text(
            CurrencyFormatter.format(value),
            style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
