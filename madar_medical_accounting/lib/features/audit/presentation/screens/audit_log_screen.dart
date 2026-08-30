import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../data/models/audit_log_entry.dart';
import '../providers/audit_log_providers.dart';

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  Color _actionColor(BuildContext context, String action) {
    final theme = Theme.of(context);
    switch (action) {
      case 'insert':
        return const Color(0xFF0F6E56);
      case 'delete':
        return theme.colorScheme.error;
      default:
        return const Color(0xFF185FA5);
    }
  }

  IconData _actionIcon(String action) {
    switch (action) {
      case 'insert':
        return Icons.add_circle_outline;
      case 'delete':
        return Icons.remove_circle_outline;
      default:
        return Icons.edit_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final logsAsync = ref.watch(auditLogListProvider);
    final filter = ref.watch(auditLogFilterProvider);

    final tableOptions = [
      (null, l10n.recordTypeAll),
      ('revenue_transactions', l10n.navRevenue),
      ('expense_transactions', l10n.navExpenses),
      ('doctors', l10n.navDoctors),
      ('services', l10n.navServices),
      ('patients', l10n.navPatients),
      ('suppliers', l10n.navSuppliers),
      ('users', l10n.usersTitle),
    ];
    final actionOptions = [
      (null, l10n.actionAll),
      ('insert', l10n.actionCreated),
      ('update', l10n.actionUpdated),
      ('delete', l10n.actionDeleted),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.auditLogTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: filter.tableName,
                    isExpanded: true,
                    decoration: const InputDecoration(isDense: true),
                    items: tableOptions
                        .map((o) => DropdownMenuItem<String?>(value: o.$1, child: Text(o.$2)))
                        .toList(),
                    onChanged: (value) => ref.read(auditLogFilterProvider.notifier).state =
                        AuditLogFilter(tableName: value, action: filter.action),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: filter.action,
                    isExpanded: true,
                    decoration: const InputDecoration(isDense: true),
                    items: actionOptions
                        .map((o) => DropdownMenuItem<String?>(value: o.$1, child: Text(o.$2)))
                        .toList(),
                    onChanged: (value) => ref.read(auditLogFilterProvider.notifier).state =
                        AuditLogFilter(tableName: filter.tableName, action: value),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: logsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('${l10n.errorGeneric} ($e)')),
              data: (logs) {
                if (logs.isEmpty) {
                  return EmptyState(icon: Icons.history, title: l10n.noMatchingAuditEntries);
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  itemCount: logs.length,
                  itemBuilder: (context, index) => _AuditLogTile(
                    entry: logs[index],
                    color: _actionColor(context, logs[index].action),
                    icon: _actionIcon(logs[index].action),
                    actionCreated: l10n.actionCreated,
                    actionUpdated: l10n.actionUpdated,
                    actionDeleted: l10n.actionDeleted,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditLogTile extends StatelessWidget {
  final AuditLogEntry entry;
  final Color color;
  final IconData icon;
  final String actionCreated;
  final String actionUpdated;
  final String actionDeleted;

  const _AuditLogTile({
    required this.entry,
    required this.color,
    required this.icon,
    required this.actionCreated,
    required this.actionUpdated,
    required this.actionDeleted,
  });

  String get _actionLabel {
    switch (entry.action) {
      case 'insert':
        return actionCreated;
      case 'delete':
        return actionDeleted;
      default:
        return actionUpdated;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 20)),
      title: Text('${entry.friendlyTableName} #${entry.recordId} $_actionLabel'),
      subtitle: Text('${entry.userName ?? '-'} · ${DateFormatter.toDisplayDateTime(entry.timestamp)}'),
      dense: true,
    );
  }
}
