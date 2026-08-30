import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/utils/date_formatter.dart';

/// Gross Revenue - Discounts = Net Revenue - Doctor Commissions = Gross
/// Profit - Operating Expenses = Net Profit. This is the reconciled
/// ordering from the architecture discussion (section 24/25 of the
/// original spec, which the worked example validates against).
class PnLReport {
  final double grossRevenue;
  final double discounts;
  final double netRevenue;
  final double doctorCommissions;
  final double grossProfit;
  final double operatingExpenses;
  final double netProfit;

  const PnLReport({
    required this.grossRevenue,
    required this.discounts,
    required this.netRevenue,
    required this.doctorCommissions,
    required this.grossProfit,
    required this.operatingExpenses,
    required this.netProfit,
  });
}

/// Opening Balance + Cash Inflows - Cash Outflows = Closing Balance,
/// computed purely from transaction history (not from the live
/// current_balance column) so it is correct for ANY historical period,
/// not just "up to today".
class AccountCashFlow {
  final String accountName;
  final double openingBalance;
  final double inflows;
  final double outflows;
  final double closingBalance;

  const AccountCashFlow({
    required this.accountName,
    required this.openingBalance,
    required this.inflows,
    required this.outflows,
    required this.closingBalance,
  });
}

class DoctorReportRow {
  final String doctorName;
  final double revenue;
  final double commission;
  final double centerShare;
  const DoctorReportRow({
    required this.doctorName,
    required this.revenue,
    required this.commission,
    required this.centerShare,
  });
}

class ServiceReportRow {
  final String serviceName;
  final int transactionCount;
  final double revenue;
  const ServiceReportRow({required this.serviceName, required this.transactionCount, required this.revenue});
}

class CategoryReportRow {
  final String categoryName;
  final int transactionCount;
  final double total;
  const CategoryReportRow({required this.categoryName, required this.transactionCount, required this.total});
}

class DailyClosingReport {
  final DateTime date;
  final double openingCash;
  final double cashRevenue;
  final double cashExpenses;
  final double closingCash;
  const DailyClosingReport({
    required this.date,
    required this.openingCash,
    required this.cashRevenue,
    required this.cashExpenses,
    required this.closingCash,
  });
}

class ReportAggregationService {
  final DatabaseHelper _databaseHelper;

  ReportAggregationService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  Future<PnLReport> getPnL(DateRange range) async {
    final db = await _databaseHelper.database;
    final start = DateFormatter.toStorage(range.start);
    final end = DateFormatter.toStorage(range.end);

    final revenueRows = await db.rawQuery('''
      SELECT COALESCE(SUM(gross_amount), 0) as gross,
             COALESCE(SUM(discount), 0) as discount,
             COALESCE(SUM(net_amount), 0) as net,
             COALESCE(SUM(doctor_commission_amount), 0) as commission
      FROM revenue_transactions
      WHERE is_deleted = 0 AND date >= ? AND date <= ?
    ''', [start, end]);
    final r = revenueRows.first;

    final expenseRows = await db.rawQuery('''
      SELECT COALESCE(SUM(amount), 0) as total
      FROM expense_transactions
      WHERE is_deleted = 0 AND date >= ? AND date <= ?
    ''', [start, end]);
    final operatingExpenses = (expenseRows.first['total'] as num).toDouble();

    final grossRevenue = (r['gross'] as num).toDouble();
    final discounts = (r['discount'] as num).toDouble();
    final netRevenue = (r['net'] as num).toDouble();
    final doctorCommissions = (r['commission'] as num).toDouble();
    final grossProfit = netRevenue - doctorCommissions;
    final netProfit = grossProfit - operatingExpenses;

    return PnLReport(
      grossRevenue: grossRevenue,
      discounts: discounts,
      netRevenue: netRevenue,
      doctorCommissions: doctorCommissions,
      grossProfit: grossProfit,
      operatingExpenses: operatingExpenses,
      netProfit: netProfit,
    );
  }

  Future<List<AccountCashFlow>> getCashFlow(DateRange range) async {
    final db = await _databaseHelper.database;
    final accounts = await db.query('payment_accounts', orderBy: 'id');

    final results = <AccountCashFlow>[];
    for (final account in accounts) {
      final accountId = account['id'] as int;
      final flow = await _computeAccountFlow(db, accountId, range);
      results.add(AccountCashFlow(
        accountName: account['name'] as String,
        openingBalance: flow.$1,
        inflows: flow.$2,
        outflows: flow.$3,
        closingBalance: flow.$1 + flow.$2 - flow.$3,
      ));
    }
    return results;
  }

  /// Returns (openingBalance, inflows, outflows) for one account over one
  /// period. Opening balance = the account's configured opening_balance
  /// plus every transaction that happened strictly before the period
  /// started; inflows/outflows are transactions strictly within the
  /// period (inclusive of both endpoints).
  Future<(double, double, double)> _computeAccountFlow(
    DatabaseExecutor db,
    int accountId,
    DateRange range,
  ) async {
    final start = DateFormatter.toStorage(range.start);
    final end = DateFormatter.toStorage(range.end);

    final accountRows = await db.query('payment_accounts', where: 'id = ?', whereArgs: [accountId]);
    final openingConfigured = (accountRows.first['opening_balance'] as num).toDouble();

    final priorRevenue = await db.rawQuery('''
      SELECT COALESCE(SUM(rt.net_amount), 0) as total
      FROM revenue_transactions rt
      INNER JOIN payment_methods pm ON rt.payment_method_id = pm.id
      WHERE pm.payment_account_id = ? AND rt.is_deleted = 0 AND rt.date < ?
    ''', [accountId, start]);
    final priorExpense = await db.rawQuery('''
      SELECT COALESCE(SUM(et.amount), 0) as total
      FROM expense_transactions et
      INNER JOIN payment_methods pm ON et.payment_method_id = pm.id
      WHERE pm.payment_account_id = ? AND et.is_deleted = 0 AND et.date < ?
    ''', [accountId, start]);

    final openingBalance = openingConfigured +
        (priorRevenue.first['total'] as num).toDouble() -
        (priorExpense.first['total'] as num).toDouble();

    final periodRevenue = await db.rawQuery('''
      SELECT COALESCE(SUM(rt.net_amount), 0) as total
      FROM revenue_transactions rt
      INNER JOIN payment_methods pm ON rt.payment_method_id = pm.id
      WHERE pm.payment_account_id = ? AND rt.is_deleted = 0 AND rt.date >= ? AND rt.date <= ?
    ''', [accountId, start, end]);
    final periodExpense = await db.rawQuery('''
      SELECT COALESCE(SUM(et.amount), 0) as total
      FROM expense_transactions et
      INNER JOIN payment_methods pm ON et.payment_method_id = pm.id
      WHERE pm.payment_account_id = ? AND et.is_deleted = 0 AND et.date >= ? AND et.date <= ?
    ''', [accountId, start, end]);

    return (
      openingBalance,
      (periodRevenue.first['total'] as num).toDouble(),
      (periodExpense.first['total'] as num).toDouble(),
    );
  }

  Future<DailyClosingReport> getDailyClosing(DateTime date) async {
    final db = await _databaseHelper.database;
    final cashAccountRows = await db.query('payment_accounts', where: 'name = ?', whereArgs: ['Cash']);
    if (cashAccountRows.isEmpty) {
      return DailyClosingReport(date: date, openingCash: 0, cashRevenue: 0, cashExpenses: 0, closingCash: 0);
    }
    final cashAccountId = cashAccountRows.first['id'] as int;
    final dayRange = DateRange(
      start: DateFormatter.startOfDay(date),
      end: DateFormatter.endOfDay(date),
      preset: DateRangePreset.custom,
    );
    final flow = await _computeAccountFlow(db, cashAccountId, dayRange);
    return DailyClosingReport(
      date: date,
      openingCash: flow.$1,
      cashRevenue: flow.$2,
      cashExpenses: flow.$3,
      closingCash: flow.$1 + flow.$2 - flow.$3,
    );
  }

  Future<List<DoctorReportRow>> getDoctorReport(DateRange range) async {
    final db = await _databaseHelper.database;
    final rows = await db.rawQuery('''
      SELECT d.name as name,
             COALESCE(SUM(rt.net_amount), 0) as revenue,
             COALESCE(SUM(rt.doctor_commission_amount), 0) as commission,
             COALESCE(SUM(rt.center_share_amount), 0) as center_share
      FROM doctors d
      LEFT JOIN revenue_transactions rt
        ON rt.doctor_id = d.id AND rt.is_deleted = 0 AND rt.date >= ? AND rt.date <= ?
      GROUP BY d.id
      ORDER BY revenue DESC
    ''', [DateFormatter.toStorage(range.start), DateFormatter.toStorage(range.end)]);

    return rows
        .map((r) => DoctorReportRow(
              doctorName: r['name'] as String,
              revenue: (r['revenue'] as num).toDouble(),
              commission: (r['commission'] as num).toDouble(),
              centerShare: (r['center_share'] as num).toDouble(),
            ))
        .toList();
  }

  Future<List<ServiceReportRow>> getServiceReport(DateRange range) async {
    final db = await _databaseHelper.database;
    final rows = await db.rawQuery('''
      SELECT s.name as name,
             COUNT(rt.id) as count,
             COALESCE(SUM(rt.net_amount), 0) as revenue
      FROM services s
      LEFT JOIN revenue_transactions rt
        ON rt.service_id = s.id AND rt.is_deleted = 0 AND rt.date >= ? AND rt.date <= ?
      GROUP BY s.id
      ORDER BY revenue DESC
    ''', [DateFormatter.toStorage(range.start), DateFormatter.toStorage(range.end)]);

    return rows
        .map((r) => ServiceReportRow(
              serviceName: r['name'] as String,
              transactionCount: (r['count'] as int?) ?? 0,
              revenue: (r['revenue'] as num).toDouble(),
            ))
        .toList();
  }

  Future<List<CategoryReportRow>> getCategoryReport(DateRange range) async {
    final db = await _databaseHelper.database;
    final rows = await db.rawQuery('''
      SELECT ec.name as name,
             COUNT(et.id) as count,
             COALESCE(SUM(et.amount), 0) as total
      FROM expense_categories ec
      LEFT JOIN expense_transactions et
        ON et.category_id = ec.id AND et.is_deleted = 0 AND et.date >= ? AND et.date <= ?
      GROUP BY ec.id
      ORDER BY total DESC
    ''', [DateFormatter.toStorage(range.start), DateFormatter.toStorage(range.end)]);

    return rows
        .map((r) => CategoryReportRow(
              categoryName: r['name'] as String,
              transactionCount: (r['count'] as int?) ?? 0,
              total: (r['total'] as num).toDouble(),
            ))
        .toList();
  }
}
