import 'dart:convert';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/constants/app_constants.dart';

/// Every repository that touches a financial or master-data table calls
/// this after a write. It is intentionally dumb and dependency-free (no
/// Riverpod, no other repositories) so it can be called from anywhere,
/// including inside a DB transaction, without risking a circular import.
class AuditLogService {
  AuditLogService._();

  static Future<void> record({
    required DatabaseExecutor db,
    required int? userId,
    required String tableName,
    required int recordId,
    required String action,
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
  }) async {
    await db.insert(AppConstants.tableAuditLogs, {
      'user_id': userId,
      'table_name': tableName,
      'record_id': recordId,
      'action': action,
      'old_value': oldValue != null ? jsonEncode(oldValue) : null,
      'new_value': newValue != null ? jsonEncode(newValue) : null,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
