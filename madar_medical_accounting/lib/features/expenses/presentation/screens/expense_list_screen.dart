import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../../domain/repositories/expense_repository.dart';
import '../providers/expense_providers.dart';
import '../widgets/expense_list_item.dart';
import 'add_edit_expense_screen.dart';
import 'expense_categories_screen.dart';
import 'expense_detail_screen.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  final _searchController = TextEditingController();

  List<(DateRangePreset?, String)> _presets(AppLocalizations l10n) => [
        (null, l10n.filterAllTime),
        (DateRangePreset.today, l10n.filterToday),
        (DateRangePreset.thisWeek, l10n.filterThisWeek),
        (DateRangePreset.thisMonth, l10n.filterThisMonth),
      ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyDatePreset(DateRangePreset? preset) {
    final current = ref.read(expenseFilterProvider);
    ref.read(expenseFilterProvider.notifier).state = ExpenseFilter(
      dateRange: preset == null ? null : DateRange.fromPreset(preset),
      categoryId: current.categoryId,
      supplierId: current.supplierId,
      paymentMethodId: current.paymentMethodId,
      searchQuery: current.searchQuery,
    );
  }

  DateRangePreset? get _selectedPreset => ref.watch(expenseFilterProvider).dateRange?.preset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listAsync = ref.watch(expenseListProvider);
    final presets = _presets(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.expensesTitle),
        actions: [
          RoleGate(
            permission: Permission.manageSettings,
            fallback: RoleGate(
              permission: Permission.addExpense,
              child: IconButton(
                icon: const Icon(Icons.category_outlined),
                tooltip: l10n.expenseCategoriesTitle,
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const ExpenseCategoriesScreen())),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.category_outlined),
              tooltip: l10n.expenseCategoriesTitle,
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const ExpenseCategoriesScreen())),
            ),
          ),
        ],
      ),
      floatingActionButton: RoleGate(
        permission: Permission.addExpense,
        child: FloatingActionButton(
          onPressed: () async {
            final saved = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => const AddEditExpenseScreen()),
            );
            if (saved == true) ref.invalidate(expenseListProvider);
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchExpenseHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          final current = ref.read(expenseFilterProvider);
                          ref.read(expenseFilterProvider.notifier).state = ExpenseFilter(
                            dateRange: current.dateRange,
                            categoryId: current.categoryId,
                            supplierId: current.supplierId,
                            paymentMethodId: current.paymentMethodId,
                            searchQuery: null,
                          );
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                final current = ref.read(expenseFilterProvider);
                ref.read(expenseFilterProvider.notifier).state = ExpenseFilter(
                  dateRange: current.dateRange,
                  categoryId: current.categoryId,
                  supplierId: current.supplierId,
                  paymentMethodId: current.paymentMethodId,
                  searchQuery: value,
                );
                setState(() {});
              },
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: presets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final (preset, label) = presets[index];
                final selected = _selectedPreset == preset;
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) => _applyDatePreset(preset),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(expenseListProvider),
              child: listAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ListView(
                  children: [
                    const SizedBox(height: 60),
                    Center(child: Text('${l10n.errorGeneric} ($e)')),
                  ],
                ),
                data: (expenses) => expenses.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 40),
                          EmptyState(
                            icon: Icons.receipt_long_outlined,
                            title: l10n.noExpensesYet,
                            message: l10n.tapAddFirstExpense,
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          return ExpenseListItem(
                            expense: expense,
                            onTap: () async {
                              final changed = await Navigator.of(context).push<bool>(
                                MaterialPageRoute(builder: (_) => ExpenseDetailScreen(expense: expense)),
                              );
                              if (changed == true) ref.invalidate(expenseListProvider);
                            },
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
