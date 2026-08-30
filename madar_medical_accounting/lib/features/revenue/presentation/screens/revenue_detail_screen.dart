import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../data/models/revenue_transaction_model.dart';
import '../providers/revenue_providers.dart';
import 'add_edit_revenue_screen.dart';

class RevenueDetailScreen extends ConsumerWidget {
  final RevenueTransactionModel transaction;

  const RevenueDetailScreen({super.key, required this.transaction});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.confirmDeleteTitle,
      message: l10n.deleteTransactionMessage,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
    );
    if (!confirmed) return;

    final user = ref.read(authProvider).currentUser;
    if (user == null || user.id == null || transaction.id == null) return;

    try {
      await ref.read(revenueRepositoryProvider).softDelete(transaction.id!, userId: user.id!);
      ref.invalidate(revenueListProvider);
      ref.invalidate(dashboardSummaryProvider);
      if (context.mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.errorGeneric} ($e)')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(transaction.transactionNo),
        actions: [
          RoleGate(
            permission: Permission.editRevenue,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final saved = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => AddEditRevenueScreen(existing: transaction)),
                );
                if (saved == true && context.mounted) Navigator.of(context).pop(true);
              },
            ),
          ),
          RoleGate(
            permission: Permission.deleteRevenue,
            child: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(context, ref),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.revenueColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(l10n.netRevenue, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(transaction.netAmount),
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.revenueColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _DetailSection(
            title: l10n.transactionSection,
            rows: [
              _DetailRow(l10n.date, DateFormatter.toDisplay(transaction.date)),
              _DetailRow(l10n.time, transaction.time),
              _DetailRow(l10n.patientCustomer, transaction.patientName ?? l10n.walkInPatient),
              _DetailRow(l10n.doctor, transaction.doctorName ?? '-'),
              _DetailRow(l10n.service, transaction.serviceName ?? '-'),
              _DetailRow(l10n.paymentMethod, transaction.paymentMethodName ?? '-'),
            ],
          ),
          const SizedBox(height: 16),
          _DetailSection(
            title: l10n.amountsSection,
            rows: [
              _DetailRow(l10n.grossAmount, CurrencyFormatter.format(transaction.grossAmount)),
              _DetailRow(l10n.discount, CurrencyFormatter.format(transaction.discount)),
              _DetailRow(l10n.netRevenue, CurrencyFormatter.format(transaction.netAmount)),
              _DetailRow(l10n.doctorCommission, CurrencyFormatter.format(transaction.doctorCommissionAmount)),
              _DetailRow(l10n.centerShare, CurrencyFormatter.format(transaction.centerShareAmount)),
            ],
          ),
          if (transaction.notes != null && transaction.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _DetailSection(title: l10n.notes, rows: [_DetailRow('', transaction.notes!)]),
          ],
          const SizedBox(height: 16),
          _DetailSection(
            title: l10n.recordInfoSection,
            rows: [
              _DetailRow(l10n.recorded, DateFormatter.toDisplayDateTime(transaction.createdAt)),
              if (transaction.modifiedAt != null)
                _DetailRow(l10n.lastModified, DateFormatter.toDisplayDateTime(transaction.modifiedAt!)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<_DetailRow> rows;

  const _DetailSection({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: row.label.isEmpty
                    ? Text(row.value)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(row.label, style: TextStyle(color: Theme.of(context).colorScheme.outline)),
                          Flexible(
                            child: Text(
                              row.value,
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
