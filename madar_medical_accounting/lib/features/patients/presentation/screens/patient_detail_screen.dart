import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../../../revenue/data/models/revenue_transaction_model.dart';
import '../../../revenue/domain/repositories/revenue_repository.dart';
import '../../../revenue/presentation/providers/revenue_providers.dart';
import '../../../revenue/presentation/widgets/revenue_list_item.dart';
import '../../data/models/patient_model.dart';
import 'add_edit_patient_screen.dart';

final _patientRevenueHistoryProvider =
    FutureProvider.autoDispose.family<List<RevenueTransactionModel>, int>((ref, patientId) async {
  final repo = ref.watch(revenueRepositoryProvider);
  return repo.getAll(RevenueFilter(patientId: patientId));
});

class PatientDetailScreen extends ConsumerWidget {
  final PatientModel patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final historyAsync = ref.watch(_patientRevenueHistoryProvider(patient.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        actions: [
          RoleGate(
            permission: Permission.managePatients,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final saved = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => AddEditPatientScreen(existing: patient)),
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
                  if (patient.phone != null && patient.phone!.isNotEmpty)
                    _InfoRow(icon: Icons.phone_outlined, label: patient.phone!),
                  if (patient.gender != null)
                    _InfoRow(
                      icon: Icons.wc_outlined,
                      label: patient.gender == 'male' ? l10n.genderMale : l10n.genderFemale,
                    ),
                  if (patient.dateOfBirth != null)
                    _InfoRow(
                      icon: Icons.cake_outlined,
                      label: DateFormatter.toDisplay(patient.dateOfBirth!),
                    ),
                  if (patient.notes != null && patient.notes!.isNotEmpty)
                    _InfoRow(icon: Icons.notes_outlined, label: patient.notes!),
                  if (patient.phone == null &&
                      patient.gender == null &&
                      patient.dateOfBirth == null &&
                      (patient.notes == null || patient.notes!.isEmpty))
                    Text(l10n.noAdditionalDetails, style: TextStyle(color: theme.colorScheme.outline)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.transactionHistory, style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          historyAsync.when(
            loading: () =>
                const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
            error: (e, _) => Text('${l10n.errorGeneric} ($e)'),
            data: (transactions) => transactions.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: EmptyState(icon: Icons.payments_outlined, title: l10n.noTransactionsForPatient),
                  )
                : Column(
                    children: transactions
                        .map((t) => RevenueListItem(transaction: t, onTap: () {}))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
