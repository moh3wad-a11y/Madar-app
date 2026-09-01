import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/expense_category_model.dart';
import '../providers/expense_category_providers.dart';

class ExpenseCategoriesScreen extends ConsumerWidget {
  const ExpenseCategoriesScreen({super.key});

  Future<void> _showAddEditDialog(
    BuildContext context,
    WidgetRef ref, {
    ExpenseCategoryModel? existing,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final nameArController = TextEditingController(text: existing?.nameAr ?? '');
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? l10n.newCategory : l10n.editCategory),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.nameEnglish),
                validator: (v) => v == null || v.trim().isEmpty ? l10n.requiredField : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nameArController,
                decoration: InputDecoration(labelText: l10n.nameArabicOptional),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(context, true);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (saved != true) return;

    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) return;
    final repo = ref.read(expenseCategoryRepositoryProvider);

    if (existing == null) {
      await repo.create(
        ExpenseCategoryModel(
          name: nameController.text.trim(),
          nameAr: nameArController.text.trim().isEmpty ? null : nameArController.text.trim(),
          isActive: true,
        ),
        userId: userId,
      );
    } else {
      await repo.update(
        existing.copyWith(
          name: nameController.text.trim(),
          nameAr: nameArController.text.trim().isEmpty ? null : nameArController.text.trim(),
        ),
        userId: userId,
      );
    }
    ref.invalidate(allExpenseCategoriesProvider);
    ref.invalidate(activeExpenseCategoriesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(allExpenseCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.expenseCategoriesTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l10n.errorGeneric} ($e)')),
        data: (categories) => categories.isEmpty
            ? EmptyState(icon: Icons.category_outlined, title: l10n.noDataFound)
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    title: Text(category.name),
                    subtitle: category.nameAr != null ? Text(category.nameAr!) : null,
                    trailing: Switch(
                      value: category.isActive,
                      onChanged: (value) async {
                        final userId = ref.read(authProvider).currentUser?.id;
                        if (userId == null || category.id == null) return;
                        await ref
                            .read(expenseCategoryRepositoryProvider)
                            .setActive(category.id!, value, userId: userId);
                        ref.invalidate(allExpenseCategoriesProvider);
                        ref.invalidate(activeExpenseCategoriesProvider);
                      },
                    ),
                    onTap: () => _showAddEditDialog(context, ref, existing: category),
                  );
                },
              ),
      ),
    );
  }
}
