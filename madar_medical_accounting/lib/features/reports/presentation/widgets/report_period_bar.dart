import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/date_formatter.dart';
import '../providers/report_providers.dart';

class ReportPeriodBar extends ConsumerWidget {
  final String reportId;

  const ReportPeriodBar({super.key, required this.reportId});

  List<(DateRangePreset, String)> _presets(AppLocalizations l10n) => [
        (DateRangePreset.today, l10n.periodDaily),
        (DateRangePreset.thisWeek, l10n.periodWeekly),
        (DateRangePreset.thisMonth, l10n.periodMonthly),
        (DateRangePreset.thisYear, l10n.periodYearly),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final current = ref.watch(reportPeriodProvider(reportId));
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
                current.preset == DateRangePreset.custom
                    ? '${DateFormatter.toDisplay(current.start)} - ${DateFormatter.toDisplay(current.end)}'
                    : l10n.filterCustom,
              ),
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                  initialDateRange: DateTimeRange(start: current.start, end: current.end),
                );
                if (picked != null) {
                  ref.read(reportPeriodProvider(reportId).notifier).state = DateRange.fromPreset(
                    DateRangePreset.custom,
                    customStart: picked.start,
                    customEnd: picked.end,
                  );
                }
              },
            );
          }
          final (preset, label) = presets[index];
          final selected = current.preset == preset;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) {
              ref.read(reportPeriodProvider(reportId).notifier).state = DateRange.fromPreset(preset);
            },
          );
        },
      ),
    );
  }
}
