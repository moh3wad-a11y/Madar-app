import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'cash_flow_report_screen.dart';
import 'category_report_screen.dart';
import 'daily_closing_report_screen.dart';
import 'doctor_report_screen.dart';
import 'expense_report_screen.dart';
import 'pnl_report_screen.dart';
import 'revenue_report_screen.dart';
import 'service_report_screen.dart';

class ReportsHubScreen extends StatelessWidget {
  const ReportsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reports = <_ReportEntry>[
      _ReportEntry(l10n.reportPnl, l10n.reportPnlSubtitle, Icons.trending_up, (_) => const PnlReportScreen()),
      _ReportEntry(
        l10n.reportCashFlow,
        l10n.reportCashFlowSubtitle,
        Icons.account_balance_wallet_outlined,
        (_) => const CashFlowReportScreen(),
      ),
      _ReportEntry(
        l10n.reportDailyClosing,
        l10n.reportDailyClosingSubtitle,
        Icons.today_outlined,
        (_) => const DailyClosingReportScreen(),
      ),
      _ReportEntry(
        l10n.reportRevenue,
        l10n.reportRevenueSubtitle,
        Icons.payments_outlined,
        (_) => const RevenueReportScreen(),
      ),
      _ReportEntry(
        l10n.reportExpense,
        l10n.reportExpenseSubtitle,
        Icons.receipt_long_outlined,
        (_) => const ExpenseReportScreen(),
      ),
      _ReportEntry(
        l10n.reportDoctor,
        l10n.reportDoctorSubtitle,
        Icons.medical_services_outlined,
        (_) => const DoctorReportScreen(),
      ),
      _ReportEntry(
        l10n.reportService,
        l10n.reportServiceSubtitle,
        Icons.medical_information_outlined,
        (_) => const ServiceReportScreen(),
      ),
      _ReportEntry(
        l10n.reportCategory,
        l10n.reportCategorySubtitle,
        Icons.category_outlined,
        (_) => const CategoryReportScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(report.icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              title: Text(report.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(report.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: report.builder)),
            ),
          );
        },
      ),
    );
  }
}

class _ReportEntry {
  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder;

  const _ReportEntry(this.title, this.subtitle, this.icon, this.builder);
}
