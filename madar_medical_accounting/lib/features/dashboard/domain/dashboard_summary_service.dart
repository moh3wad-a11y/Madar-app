import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/utils/date_formatter.dart';

class ChartEntry {
  final String label;
  final double value;
  const ChartEntry(this.label, this.value);
}

class DashboardSummary {
  final double todayRevenue;
  final double todayExpenses;
  final double todayNetProfit;
  final double cashBalance;
  final double totalBalanceAllAccounts;
  final double periodRevenue;
  final double periodExpenses;
  final double periodNetProfit;
  final int periodTransactionCount;
  final List<ChartEntry> revenueByDoctor;
  final List<ChartEntry> revenueByService;
  final List<ChartEntry> expensesByCategory;

  const DashboardSummary({
    required this.todayRevenue,
    required this.todayExpenses,
    required this.todayNetProfit,
    required this.cashBalance,
    required this.totalBalanceAllAccounts,
    required this.periodRevenue,
    required this.periodExpenses,
    required this.periodNetProfit,
    required this.periodTransactionCount,
    required this.revenueByDoctor,
    required this.revenueByService,
    required this.expensesByCategory,
  });
}

/// All dashboard numbers come from live SQL aggregates over
/// revenue_transactions / expense_transactions / payment_accounts -
/// nothing is cached or denormalized, so the dashboard is always
/// consistent with the transaction tables it reads from.
class DashboardSummaryService {
  final DatabaseHelper _databaseHelper;

  DashboardSummaryService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  Future<DashboardSummary> load(DateRange period) async {
    final db = await _databaseHelper.database;
    final today = DateRange.fromPreset(DateRangePreset.today);

    final todayRevenue = await _sumRevenue(db, today);
    final todayExpenses = await _sumExpenses(db, today);

    final periodRevenue = await _sumRevenue(db, period);
    final periodExpenses = await _sumExpenses(db, period);
    final periodTransactionCount = await _countTransactions(db, period);

    final cashBalance = await _accountBalance(db, 'Cash');
    final totalBalance = await _totalBalance(db);

    final revenueByDoctor = await _revenueByDoctor(db, period);
    final revenueByService = await _revenueByService(db, period);
    final expensesByCategory = await _expensesByCategory(db, period);

    return DashboardSummary(
      todayRevenue: todayRevenue,
      todayExpenses: todayExpenses,
      todayNetProfit: todayRevenue - todayExpenses,
      cashBalance: cashBalance,
      totalBalanceAllAccounts: totalBalance,
      periodRevenue: periodRevenue,
      periodExpenses: periodExpenses,
      periodNetProfit: periodRevenue - periodExpenses,
      periodTransactionCount: periodTransactionCount,
      revenueByDoctor: revenueByDoctor,
      revenueByService: revenueByService,
      expensesByCategory: expensesByCategory,
    );
  }

  Future<double> _sumRevenue(Database db, DateRange range) async {
    final rows = await db.rawQuery(
      'SELECT COALESCE(SUM(net_amount), 0) as total FROM revenue_transactions '
      'WHERE is_deleted = 0 AND date >= ? AND date <= ?',
      [DateFormatter.toStorage(range.start), DateFormatter.toStorage(range.end)],
    );
    return (rows.first['total'] as num).toDouble();
  }

  Future<double> _sumExpenses(Database db, DateRange range) async {
    final rows = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM expense_transactions '
      'WHERE is_deleted = 0 AND date >= ? AND date <= ?',
      [DateFormatter.toStorage(range.start), DateFormatter.toStorage(range.end)],
    );
    return (rows.first['total'] as num).toDouble();
  }

  Future<int> _countTransactions(Database db, DateRange range) async {
    final revenueRows = await db.rawQuery(
      'SELECT COUNT(*) as count FROM revenue_transactions '
      'WHERE is_deleted = 0 AND date >= ? AND date <= ?',
      [DateFormatter.toStorage(range.start), DateFormatter.toStorage(range.end)],
    );
    final expenseRows = await db.rawQuery(
      'SELECT COUNT(*) as count FROM expense_transactions '
      'WHERE is_deleted = 0 AND date >= ? AND date <= ?',
      [DateFormatter.toStorage(range.start), DateFormatter.toStorage(range.end)],
    );
    return ((revenueRows.first['count'] as int?) ?? 0) + ((expenseRows.first['count'] as int?) ?? 0);
  }

  Future<double> _accountBalance(Database db, String accountName) async {
    final rows = await db.query('payment_accounts', where: 'name = ?', whereArgs: [accountName]);
    if (rows.isEmpty) return 0;
    return (rows.first['current_balance'] as num).toDouble();
  }

  Future<double> _totalBalance(Database db) async {
    final rows =
        await db.rawQuery('SELECT COALESCE(SUM(current_balance), 0) as total FROM payment_accounts');
    return (rows.first['total'] as num).toDouble();
  }

  Future<List<ChartEntry>> _revenueByDoctor(Database db, DateRange range) async {
    final rows = await db.rawQuery('''
      SELECT d.name as label, COALESCE(SUM(rt.net_amount), 0) as value
      FROM revenue_transactions rt
      INNER JOIN doctors d ON rt.doctor_id = d.id
      WHERE rt.is_deleted = 0 AND rt.date >= ? AND rt.date <= ?
      GROUP BY d.id
      ORDER BY value DESC
      LIMIT 8
    ''', [DateFormatter.toStorage(range.start), DateFormatter.toStorage(range.end)]);
    return rows.map((r) => ChartEntry(r['label'] as String, (r['value'] as num).toDouble())).toList();
  }

  Future<List<ChartEntry>> _revenueByService(Database db, DateRange range) async {
    final rows = await db.rawQuery('''
      SELECT s.name as label, COALESCE(SUM(rt.net_amount), 0) as value
      FROM revenue_transactions rt
      INNER JOIN services s ON rt.service_id = s.id
      WHERE rt.is_deleted = 0 AND rt.date >= ? AND rt.date <= ?
      GROUP BY s.id
      ORDER BY value DESC
      LIMIT 8
    ''', [DateFormatter.toStorage(range.start), DateFormatter.toStorage(range.end)]);
    return rows.map((r) => ChartEntry(r['label'] as String, (r['value'] as num).toDouble())).toList();
  }

  Future<List<ChartEntry>> _expensesByCategory(Database db, DateRange range) async {
    final rows = await db.rawQuery('''
      SELECT ec.name as label, COALESCE(SUM(et.amount), 0) as value
      FROM expense_transactions et
      INNER JOIN expense_categories ec ON et.category_id = ec.id
      WHERE et.is_deleted = 0 AND et.date >= ? AND et.date <= ?
      GROUP BY ec.id
      ORDER BY value DESC
      LIMIT 8
    ''', [DateFormatter.toStorage(range.start), DateFormatter.toStorage(range.end)]);
    return rows.map((r) => ChartEntry(r['label'] as String, (r['value'] as num).toDouble())).toList();
  }
}
