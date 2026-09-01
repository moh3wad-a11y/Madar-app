import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../../data/models/doctor_model.dart';
import '../providers/doctor_providers.dart';
import 'add_edit_doctor_screen.dart';

class DoctorDetailScreen extends ConsumerWidget {
  final DoctorModel doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final summaryAsync = ref.watch(doctorRevenueSummaryProvider(doctor.id!));
    final theme = Theme.of(context);

    final commissionLine = doctor.commissionType == 'none'
        ? l10n.commissionNone
        : doctor.commissionType == 'percentage'
            ? '${l10n.commissionPercentage}: ${doctor.commissionValue.toStringAsFixed(0)}%'
            : '${l10n.commissionFixed}: ${CurrencyFormatter.format(doctor.commissionValue)}';

    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
        actions: [
          RoleGate(
            permission: Permission.manageDoctors,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final saved = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => AddEditDoctorScreen(existing: doctor)),
                );
                if (saved == true && context.mounted) Navigator.of(context).pop(true);
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (doctor.specialty != null && doctor.specialty!.isNotEmpty)
                    Text(doctor.specialty!, style: theme.textTheme.bodyMedium),
                  if (doctor.phone != null && doctor.phone!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone_outlined, size: 16, color: theme.colorScheme.outline),
                        const SizedBox(width: 6),
                        Text(doctor.phone!),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(commissionLine, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.allTimePerformance, style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          summaryAsync.when(
            loading: () => const Center(
                child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
            error: (e, _) => Text('${l10n.errorGeneric} ($e)'),
            data: (summary) => Column(
              children: [
                _StatRow(
                  label: l10n.revenueGenerated,
                  value: CurrencyFormatter.format(summary.totalRevenue),
                  color: AppTheme.revenueColor,
                ),
                _StatRow(
                  label: l10n.commissionPaidToDoctor,
                  value: CurrencyFormatter.format(summary.totalCommission),
                  color: AppTheme.warningColor,
                ),
                _StatRow(
                  label: l10n.centerShare,
                  value: CurrencyFormatter.format(summary.totalCenterShare),
                  color: AppTheme.profitColor,
                ),
                _StatRow(
                  label: l10n.transactionCount,
                  value: summary.transactionCount.toString(),
                  color: theme.colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}
