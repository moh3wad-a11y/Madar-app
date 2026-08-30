import 'package:sqflite_sqlcipher/sqflite.dart';
import 'date_formatter.dart';

/// Generates human-readable sequential transaction numbers scoped to a day,
/// e.g. REV-20260829-0001. Counting existing rows (including soft-deleted
/// ones) for the day guarantees the number is never reused even after a
/// deletion, which matters for audit trails.
///
/// Takes a [DatabaseExecutor] rather than a [Database] deliberately: both
/// revenue and expense repositories call this from inside a
/// `db.transaction()` callback, which hands back a [Transaction] object -
/// not a [Database]. DatabaseExecutor is the common interface both
/// implement, and it's all this class actually needs (rawQuery only).
class IdGenerator {
  IdGenerator._();

  static Future<String> nextRevenueNo(DatabaseExecutor db, DateTime date) {
    return _nextSequential(db, 'revenue_transactions', 'transaction_no', 'REV', date);
  }

  static Future<String> nextExpenseNo(DatabaseExecutor db, DateTime date) {
    return _nextSequential(db, 'expense_transactions', 'expense_no', 'EXP', date);
  }

  static Future<String> _nextSequential(
    DatabaseExecutor db,
    String table,
    String column,
    String prefix,
    DateTime date,
  ) async {
    final datePart = DateFormatter.toStorage(date).replaceAll('-', '');
    final likePattern = '$prefix-$datePart-%';
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $table WHERE $column LIKE ?',
      [likePattern],
    );
    final count = (result.first['count'] as int?) ?? 0;
    final nextNumber = (count + 1).toString().padLeft(4, '0');
    return '$prefix-$datePart-$nextNumber';
  }
}
