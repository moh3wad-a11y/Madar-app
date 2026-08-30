import '../../../../core/utils/date_formatter.dart';
import '../../data/models/revenue_transaction_model.dart';

class RevenueFilter {
  final DateRange? dateRange;
  final int? doctorId;
  final int? serviceId;
  final int? paymentMethodId;
  final int? patientId;
  final String? searchQuery;

  const RevenueFilter({
    this.dateRange,
    this.doctorId,
    this.serviceId,
    this.paymentMethodId,
    this.patientId,
    this.searchQuery,
  });
}

abstract class RevenueRepository {
  Future<List<RevenueTransactionModel>> getAll(RevenueFilter filter);
  Future<RevenueTransactionModel?> getById(int id);

  /// Inserts the transaction, computes the doctor commission split,
  /// posts the net amount to the correct payment account, and writes
  /// the audit log entry - all inside one atomic DB transaction.
  Future<RevenueTransactionModel> create(RevenueTransactionModel transaction);

  /// Reverses the old balance/commission effect and re-applies the new
  /// one, atomically, so edits never leave payment account balances or
  /// commission totals out of sync with the transaction row.
  Future<void> update(RevenueTransactionModel transaction);

  /// Soft delete: reverses the balance effect, marks is_deleted = 1,
  /// and records the deletion in the audit log. The row is never
  /// physically removed (section 18).
  Future<void> softDelete(int id, {required int userId});

  /// Flags transactions with the same patient/doctor/amount within a
  /// short time window, to help catch accidental double-entry
  /// (section 22: "prevent accidental duplicate transactions").
  Future<bool> hasLikelyDuplicate({
    required int? patientId,
    required int doctorId,
    required double grossAmount,
    required DateTime date,
  });
}
