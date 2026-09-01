import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';

class RevenueExpenseBarChart extends StatelessWidget {
  final double revenue;
  final double expenses;

  const RevenueExpenseBarChart({super.key, required this.revenue, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final maxValue = [revenue, expenses, 1.0].reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxValue * 1.25,
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final label = value == 0 ? l10n.monthlyRevenue : l10n.monthlyExpenses;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(label, style: const TextStyle(fontSize: 12)),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  CurrencyFormatter.format(rod.toY),
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              },
            ),
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(
                toY: revenue,
                color: AppTheme.revenueColor,
                width: 36,
                borderRadius: BorderRadius.circular(6),
              ),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(
                toY: expenses,
                color: AppTheme.expenseColor,
                width: 36,
                borderRadius: BorderRadius.circular(6),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
