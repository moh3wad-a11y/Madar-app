import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/dashboard_summary_service.dart';

class BreakdownBarList extends StatelessWidget {
  final List<ChartEntry> entries;
  final Color color;
  final String emptyLabel;

  const BreakdownBarList({
    super.key,
    required this.entries,
    required this.color,
    this.emptyLabel = 'No data for this period',
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(emptyLabel, style: TextStyle(color: Theme.of(context).colorScheme.outline)),
        ),
      );
    }
    final maxValue = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    return Column(
      children: entries.map((entry) {
        final ratio = maxValue == 0 ? 0.0 : (entry.value / maxValue).clamp(0.0, 1.0);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      entry.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    CurrencyFormatter.format(entry.value),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
