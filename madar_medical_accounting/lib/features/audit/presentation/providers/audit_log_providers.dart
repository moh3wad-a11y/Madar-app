import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';
import '../../data/models/audit_log_entry.dart';

class AuditLogFilter {
  final String? tableName;
  final String? action;

  const AuditLogFilter({this.tableName, this.action});
}

final auditLogFilterProvider = StateProvider.autoDispose<AuditLogFilter>((ref) => const AuditLogFilter());

final auditLogListProvider = FutureProvider.autoDispose<List<AuditLogEntry>>((ref) async {
  final filter = ref.watch(auditLogFilterProvider);
  final db = await DatabaseHelper.instance.database;

  final conditions = <String>[];
  final args = <dynamic>[];
  if (filter.tableName != null) {
    conditions.add('al.table_name = ?');
    args.add(filter.tableName);
  }
  if (filter.action != null) {
    conditions.add('al.action = ?');
    args.add(filter.action);
  }
  final whereClause = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

  final rows = await db.rawQuery('''
    SELECT al.*, u.full_name as user_name
    FROM audit_logs al
    LEFT JOIN users u ON al.user_id = u.id
    $whereClause
    ORDER BY al.timestamp DESC
    LIMIT 500
  ''', args);

  return rows.map(AuditLogEntry.fromMap).toList();
});
