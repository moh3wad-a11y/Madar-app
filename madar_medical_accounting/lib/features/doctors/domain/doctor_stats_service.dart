import '../../../core/database/database_helper.dart';

class DoctorRevenueSummary {
  final double totalRevenue;
  final double totalCommission;
  final double totalCenterShare;
  final int transactionCount;

  const DoctorRevenueSummary({
    required this.totalRevenue,
    required this.totalCommission,
    required this.totalCenterShare,
    required this.transactionCount,
  });
}

class DoctorStatsService {
  final DatabaseHelper _databaseHelper;

  DoctorStatsService({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  /// All-time totals for a doctor. A date-range picker can be added here
  /// later without changing the call site - the FutureProvider that wraps
  /// this already keys on doctorId, so adding a range parameter is a
  /// backward-compatible extension, not a breaking one.
  Future<DoctorRevenueSummary> getSummary(int doctorId) async {
    final db = await _databaseHelper.database;
    final rows = await db.rawQuery('''
      SELECT COALESCE(SUM(net_amount), 0) as revenue,
             COALESCE(SUM(doctor_commission_amount), 0) as commission,
             COALESCE(SUM(center_share_amount), 0) as center_share,
             COUNT(*) as count
      FROM revenue_transactions
      WHERE doctor_id = ? AND is_deleted = 0
    ''', [doctorId]);
    final row = rows.first;
    return DoctorRevenueSummary(
      totalRevenue: (row['revenue'] as num).toDouble(),
      totalCommission: (row['commission'] as num).toDouble(),
      totalCenterShare: (row['center_share'] as num).toDouble(),
      transactionCount: (row['count'] as int?) ?? 0,
    );
  }
}
