import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../payment_accounts/data/models/payment_account_model.dart';
import '../../../payment_accounts/data/models/payment_method_model.dart';
import '../../../payment_accounts/presentation/providers/payment_account_providers.dart';

final _allMethodsProvider = FutureProvider.autoDispose<List<PaymentMethodModel>>((ref) async {
  final repo = ref.watch(paymentAccountRepositoryProvider);
  return repo.getAllMethods();
});

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref, List<PaymentAccountModel> accounts) async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    int? accountId = accounts.isNotEmpty ? accounts.first.id : null;
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.newPaymentMethod),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.methodName),
                  validator: (v) => v == null || v.trim().isEmpty ? l10n.requiredField : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: accountId,
                  decoration: InputDecoration(labelText: l10n.postsToAccount),
                  items: accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                  onChanged: (value) => setDialogState(() => accountId = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate() && accountId != null) Navigator.pop(context, true);
              },
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );

    if (saved != true || accountId == null) return;

    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) return;

    await ref.read(paymentAccountRepositoryProvider).createMethod(
          PaymentMethodModel(name: nameController.text.trim(), paymentAccountId: accountId!, isActive: true),
          userId: userId,
        );
    ref.invalidate(_allMethodsProvider);
    ref.invalidate(activePaymentMethodsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final methodsAsync = ref.watch(_allMethodsProvider);
    final accountsAsync = ref.watch(allPaymentAccountsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentMethodsTitle)),
      floatingActionButton: accountsAsync.maybeWhen(
        data: (accounts) => FloatingActionButton(
          onPressed: () => _showAddDialog(context, ref, accounts),
          child: const Icon(Icons.add),
        ),
        orElse: () => null,
      ),
      body: methodsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l10n.errorGeneric} ($e)')),
        data: (methods) => accountsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('${l10n.errorGeneric} ($e)')),
          data: (accounts) {
            final accountNameById = {for (final a in accounts) a.id: a.name};
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
              itemCount: methods.length,
              itemBuilder: (context, index) {
                final method = methods[index];
                return ListTile(
                  title: Text(method.name),
                  subtitle: Text('${l10n.postsToAccount}: ${accountNameById[method.paymentAccountId] ?? '-'}'),
                  trailing: Switch(
                    value: method.isActive,
                    onChanged: (value) async {
                      final userId = ref.read(authProvider).currentUser?.id;
                      if (userId == null || method.id == null) return;
                      await ref
                          .read(paymentAccountRepositoryProvider)
                          .setMethodActive(method.id!, value, userId: userId);
                      ref.invalidate(_allMethodsProvider);
                      ref.invalidate(activePaymentMethodsProvider);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
