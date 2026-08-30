import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/breakdown_bar_list.dart';
import '../widgets/date_filter_bar.dart';
import '../widgets/revenue_expense_bar_chart.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final user = ref.watch(authProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navDashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dashboardSummaryProvider),
        child: summaryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            children: [
              const SizedBox(height: 80),
              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 48),
              const SizedBox(height: 12),
              Center(child: Text('${l10n.errorGeneric} ($error)')),
            ],
          ),
          data: (summary) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (user != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    l10n.welcomeUser(user.fullName),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              const DateFilterBar(),
              const SizedBox(height: 20),
              Text(l10n.todayLabel, style: AppTextStyles.sectionTitle),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  StatCard(
                    label: l10n.todayRevenue,
                    value: summary.todayRevenue,
                    color: AppTheme.revenueColor,
                    icon: Icons.trending_up,
                  ),
                  StatCard(
                    label: l10n.todayExpenses,
                    value: summary.todayExpenses,
                    color: AppTheme.expenseColor,
                    icon: Icons.trending_down,
                  ),
                  StatCard(
                    label: l10n.todayNetProfit,
                    value: summary.todayNetProfit,
                    color: AppTheme.profitColor,
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  StatCard(
                    label: l10n.cashBalance,
                    value: summary.cashBalance,
                    color: AppTheme.revenueColor,
                    icon: Icons.payments_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(l10n.selectedPeriod, style: AppTextStyles.sectionTitle),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  StatCard(
                    label: l10n.monthlyRevenue,
                    value: summary.periodRevenue,
                    color: AppTheme.revenueColor,
                    icon: Icons.payments,
                  ),
                  StatCard(
                    label: l10n.monthlyExpenses,
                    value: summary.periodExpenses,
                    color: AppTheme.expenseColor,
                    icon: Icons.receipt_long,
                  ),
                  StatCard(
                    label: l10n.monthlyNetProfit,
                    value: summary.periodNetProfit,
                    color: AppTheme.profitColor,
                    icon: Icons.savings_outlined,
                  ),
                  StatCard(
                    label: l10n.transactionCount,
                    value: summary.periodTransactionCount.toDouble(),
                    color: AppTheme.profitColor,
                    icon: Icons.receipt,
                    isCurrency: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _ChartCard(
                title: l10n.chartRevenueVsExpenses,
                child: RevenueExpenseBarChart(
                  revenue: summary.periodRevenue,
                  expenses: summary.periodExpenses,
                ),
              ),
              const SizedBox(height: 16),
              _ChartCard(
                title: l10n.chartRevenueByDoctor,
                child: BreakdownBarList(
                  entries: summary.revenueByDoctor,
                  color: AppTheme.revenueColor,
                  emptyLabel: l10n.noDataForPeriod,
                ),
              ),
              const SizedBox(height: 16),
              _ChartCard(
                title: l10n.chartRevenueByService,
                child: BreakdownBarList(
                  entries: summary.revenueByService,
                  color: AppTheme.profitColor,
                  emptyLabel: l10n.noDataForPeriod,
                ),
              ),
              const SizedBox(height: 16),
              _ChartCard(
                title: l10n.chartExpensesByCategory,
                child: BreakdownBarList(
                  entries: summary.expensesByCategory,
                  color: AppTheme.expenseColor,
                  emptyLabel: l10n.noDataForPeriod,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.sectionTitle),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
