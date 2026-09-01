import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/date_formatter.dart';
import '../providers/dashboard_provider.dart';

class DateFilterBar extends ConsumerWidget {
  const DateFilterBar({super.key});

  List<(DateRangePreset, String)> _presets(AppLocalizations l10n) => [
        (DateRangePreset.today, l10n.filterToday),
        (DateRangePreset.yesterday, l10n.filterYesterday),
        (DateRangePreset.thisWeek, l10n.filterThisWeek),
        (DateRangePreset.thisMonth, l10n.filterThisMonth),
        (DateRangePreset.lastMonth, l10n.filterLastMonth),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentRange = ref.watch(dashboardDateRangeProvider);
    final presets = _presets(l10n);
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: presets.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == presets.length) {
            return ActionChip(
              avatar: const Icon(Icons.date_range, size: 16),
              label: Text(
                currentRange.preset == DateRangePreset.custom
                    ? '${DateFormatter.toDisplay(currentRange.start)} - ${DateFormatter.toDisplay(currentRange.end)}'
                    : l10n.filterCustom,
              ),
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                  initialDateRange: DateTimeRange(start: currentRange.start, end: currentRange.end),
                );
                if (picked != null) {
                  ref.read(dashboardDateRangeProvider.notifier).state = DateRange.fromPreset(
                    DateRangePreset.custom,
                    customStart: picked.start,
                    customEnd: picked.end,
                  );
                }
              },
            );
          }
          final (preset, label) = presets[index];
          final selected = currentRange.preset == preset;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) {
              ref.read(dashboardDateRangeProvider.notifier).state = DateRange.fromPreset(preset);
            },
          );
        },
      ),
    );
  }
}
