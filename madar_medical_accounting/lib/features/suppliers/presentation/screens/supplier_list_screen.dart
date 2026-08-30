import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../providers/supplier_providers.dart';
import '../widgets/supplier_list_item.dart';
import 'add_edit_supplier_screen.dart';
import 'supplier_detail_screen.dart';

class SupplierListScreen extends ConsumerStatefulWidget {
  const SupplierListScreen({super.key});

  @override
  ConsumerState<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends ConsumerState<SupplierListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final suppliersAsync = ref.watch(supplierSearchProvider(_query));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.suppliersTitle)),
      floatingActionButton: RoleGate(
        permission: Permission.manageSuppliers,
        child: FloatingActionButton(
          onPressed: () async {
            final saved = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => const AddEditSupplierScreen()),
            );
            if (saved == true) ref.invalidate(supplierSearchProvider);
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
              decoration: InputDecoration(hintText: l10n.search, prefixIcon: const Icon(Icons.search)),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(supplierSearchProvider),
              child: suppliersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ListView(
                  children: [const SizedBox(height: 60), Center(child: Text('${l10n.errorGeneric} ($e)'))],
                ),
                data: (suppliers) => suppliers.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 40),
                          EmptyState(icon: Icons.local_shipping_outlined, title: l10n.noSuppliersYet),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                        itemCount: suppliers.length,
                        itemBuilder: (context, index) {
                          final supplier = suppliers[index];
                          return SupplierListItem(
                            supplier: supplier,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => SupplierDetailScreen(supplier: supplier)),
                            ),
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
