import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../../domain/repositories/revenue_repository.dart';
import '../providers/revenue_providers.dart';
import '../widgets/revenue_list_item.dart';
import 'add_edit_revenue_screen.dart';
import 'revenue_detail_screen.dart';

class RevenueListScreen extends ConsumerStatefulWidget {
  const RevenueListScreen({super.key});

  @override
  ConsumerState<RevenueListScreen> createState() => _RevenueListScreenState();
}

class _RevenueListScreenState extends ConsumerState<RevenueListScreen> {
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
    final current = ref.read(revenueFilterProvider);
    ref.read(revenueFilterProvider.notifier).state = RevenueFilter(
      dateRange: preset == null ? null : DateRange.fromPreset(preset),
      doctorId: current.doctorId,
      serviceId: current.serviceId,
      paymentMethodId: current.paymentMethodId,
      searchQuery: current.searchQuery,
    );
  }

  DateRangePreset? get _selectedPreset => ref.watch(revenueFilterProvider).dateRange?.preset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listAsync = ref.watch(revenueListProvider);
    final presets = _presets(l10n);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.revenueTitle)),
      floatingActionButton: RoleGate(
        permission: Permission.addRevenue,
        child: FloatingActionButton(
          onPressed: () async {
            final saved = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => const AddEditRevenueScreen()),
            );
            if (saved == true) ref.invalidate(revenueListProvider);
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
                hintText: l10n.searchRevenueHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          final current = ref.read(revenueFilterProvider);
                          ref.read(revenueFilterProvider.notifier).state = RevenueFilter(
                            dateRange: current.dateRange,
                            doctorId: current.doctorId,
                            serviceId: current.serviceId,
                            paymentMethodId: current.paymentMethodId,
                            searchQuery: null,
                          );
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                final current = ref.read(revenueFilterProvider);
                ref.read(revenueFilterProvider.notifier).state = RevenueFilter(
                  dateRange: current.dateRange,
                  doctorId: current.doctorId,
                  serviceId: current.serviceId,
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
              onRefresh: () async => ref.invalidate(revenueListProvider),
              child: listAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ListView(
                  children: [
                    const SizedBox(height: 60),
                    Center(child: Text('${l10n.errorGeneric} ($e)')),
                  ],
                ),
                data: (transactions) => transactions.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 40),
                          EmptyState(
                            icon: Icons.payments_outlined,
                            title: l10n.noRevenueYet,
                            message: l10n.tapAddFirstTransaction,
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return RevenueListItem(
                            transaction: transaction,
                            onTap: () async {
                              final changed = await Navigator.of(context).push<bool>(
                                MaterialPageRoute(
                                  builder: (_) => RevenueDetailScreen(transaction: transaction),
                                ),
                              );
                              if (changed == true) ref.invalidate(revenueListProvider);
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
