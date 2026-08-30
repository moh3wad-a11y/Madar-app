import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../providers/service_providers.dart';
import '../widgets/service_list_item.dart';
import 'add_edit_service_screen.dart';

class ServiceListScreen extends ConsumerWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final servicesAsync = ref.watch(allServicesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.servicesTitle)),
      floatingActionButton: RoleGate(
        permission: Permission.manageServices,
        child: FloatingActionButton(
          onPressed: () async {
            final saved = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => const AddEditServiceScreen()),
            );
            if (saved == true) {
              ref.invalidate(allServicesProvider);
              ref.invalidate(activeServicesProvider);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(allServicesProvider),
        child: servicesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            children: [const SizedBox(height: 60), Center(child: Text('${l10n.errorGeneric} ($e)'))],
          ),
          data: (services) => services.isEmpty
              ? ListView(
                  children: [
                    const SizedBox(height: 40),
                    EmptyState(icon: Icons.medical_information_outlined, title: l10n.noDataFound),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return ServiceListItem(
                      service: service,
                      onTap: () async {
                        final saved = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(builder: (_) => AddEditServiceScreen(existing: service)),
                        );
                        if (saved == true) {
                          ref.invalidate(allServicesProvider);
                          ref.invalidate(activeServicesProvider);
                        }
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
