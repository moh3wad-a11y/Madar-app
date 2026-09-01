import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../providers/auth_provider.dart';
import 'add_edit_user_screen.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.usersTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.of(context)
              .push<bool>(MaterialPageRoute(builder: (_) => const AddEditUserScreen()));
          if (saved == true) ref.invalidate(allUsersProvider);
        },
        child: const Icon(Icons.add),
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l10n.errorGeneric} ($e)')),
        data: (users) {
          if (users.isEmpty) {
            return EmptyState(icon: Icons.people_outline, title: l10n.noDataFound);
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      user.isActive ? Theme.of(context).colorScheme.primaryContainer : Colors.grey.shade300,
                  child: const Icon(Icons.person_outline),
                ),
                title: Text(user.fullName, style: TextStyle(color: user.isActive ? null : Colors.grey)),
                subtitle: Text('@${user.username} · ${user.roleName}'),
                trailing: !user.isActive
                    ? Chip(
                        label: Text(l10n.inactive, style: const TextStyle(fontSize: 11)),
                        visualDensity: VisualDensity.compact,
                      )
                    : const Icon(Icons.chevron_right),
                onTap: () async {
                  final saved = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(builder: (_) => AddEditUserScreen(existing: user)),
                  );
                  if (saved == true) ref.invalidate(allUsersProvider);
                },
              );
            },
          );
        },
      ),
    );
  }
}
