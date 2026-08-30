import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../../../expenses/data/models/expense_transaction_model.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../../../expenses/presentation/providers/expense_providers.dart';
import '../../../expenses/presentation/widgets/expense_list_item.dart';
import '../../data/models/supplier_model.dart';
import 'add_edit_supplier_screen.dart';

final _supplierExpenseHistoryProvider =
    FutureProvider.autoDispose.family<List<ExpenseTransactionModel>, int>((ref, supplierId) async {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.getAll(ExpenseFilter(supplierId: supplierId));
});

class SupplierDetailScreen extends ConsumerWidget {
  final SupplierModel supplier;

  const SupplierDetailScreen({super.key, required this.supplier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final historyAsync = ref.watch(_supplierExpenseHistoryProvider(supplier.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(supplier.name),
        actions: [
          RoleGate(
            permission: Permission.manageSuppliers,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final saved = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => AddEditSupplierScreen(existing: supplier)),
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
                  if (supplier.phone != null && supplier.phone!.isNotEmpty)
                    _InfoRow(icon: Icons.phone_outlined, label: supplier.phone!),
                  if (supplier.address != null && supplier.address!.isNotEmpty)
                    _InfoRow(icon: Icons.location_on_outlined, label: supplier.address!),
                  if (supplier.taxId != null && supplier.taxId!.isNotEmpty)
                    _InfoRow(icon: Icons.badge_outlined, label: supplier.taxId!),
                  if (supplier.notes != null && supplier.notes!.isNotEmpty)
                    _InfoRow(icon: Icons.notes_outlined, label: supplier.notes!),
                  if ((supplier.phone == null || supplier.phone!.isEmpty) &&
                      (supplier.address == null || supplier.address!.isEmpty) &&
                      (supplier.taxId == null || supplier.taxId!.isEmpty) &&
                      (supplier.notes == null || supplier.notes!.isEmpty))
                    Text(l10n.noAdditionalDetails, style: TextStyle(color: theme.colorScheme.outline)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.expenseHistory, style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          historyAsync.when(
            loading: () =>
                const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
            error: (e, _) => Text('${l10n.errorGeneric} ($e)'),
            data: (expenses) => expenses.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: EmptyState(icon: Icons.receipt_long_outlined, title: l10n.noExpensesForSupplier),
                  )
                : Column(
                    children: expenses.map((e) => ExpenseListItem(expense: e, onTap: () {})).toList(),
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
