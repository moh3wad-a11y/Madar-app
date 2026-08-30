import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../audit/data/audit_log_service.dart';
import '../../../doctors/data/models/doctor_model.dart';
import '../../../payment_accounts/data/repositories/payment_account_repository_impl.dart';
import '../../domain/repositories/revenue_repository.dart';
import '../models/revenue_transaction_model.dart';

class RevenueRepositoryImpl implements RevenueRepository {
  final DatabaseHelper _databaseHelper;
  final PaymentAccountRepositoryImpl _paymentAccountRepository;

  RevenueRepositoryImpl({
    DatabaseHelper? databaseHelper,
    PaymentAccountRepositoryImpl? paymentAccountRepository,
  })  : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
        _paymentAccountRepository = paymentAccountRepository ?? PaymentAccountRepositoryImpl();

  static const String _joinedSelect = '''
    SELECT rt.*,
           p.name as patient_name,
           d.name as doctor_name,
           s.name as service_name,
           pm.name as payment_method_name
    FROM revenue_transactions rt
    LEFT JOIN patients p ON rt.patient_id = p.id
    INNER JOIN doctors d ON rt.doctor_id = d.id
    INNER JOIN services s ON rt.service_id = s.id
    INNER JOIN payment_methods pm ON rt.payment_method_id = pm.id
  ''';

  @override
  Future<List<RevenueTransactionModel>> getAll(RevenueFilter filter) async {
    final db = await _databaseHelper.database;
    final conditions = <String>['rt.is_deleted = 0'];
    final args = <dynamic>[];

    if (filter.dateRange != null) {
      conditions.add('rt.date >= ? AND rt.date <= ?');
      args.add(filter.dateRange!.start.toIso8601String().split('T').first);
      args.add(filter.dateRange!.end.toIso8601String().split('T').first);
    }
    if (filter.doctorId != null) {
      conditions.add('rt.doctor_id = ?');
      args.add(filter.doctorId);
    }
    if (filter.serviceId != null) {
      conditions.add('rt.service_id = ?');
      args.add(filter.serviceId);
    }
    if (filter.paymentMethodId != null) {
      conditions.add('rt.payment_method_id = ?');
      args.add(filter.paymentMethodId);
    }
    if (filter.patientId != null) {
      conditions.add('rt.patient_id = ?');
      args.add(filter.patientId);
    }
    if (filter.searchQuery != null && filter.searchQuery!.trim().isNotEmpty) {
      conditions.add('(p.name LIKE ? OR rt.transaction_no LIKE ?)');
      final q = '%${filter.searchQuery!.trim()}%';
      args.addAll([q, q]);
    }

    final rows = await db.rawQuery(
      '$_joinedSelect WHERE ${conditions.join(' AND ')} ORDER BY rt.date DESC, rt.time DESC, rt.id DESC',
      args,
    );
    return rows.map(RevenueTransactionModel.fromMap).toList();
  }

  @override
  Future<RevenueTransactionModel?> getById(int id) async {
    final db = await _databaseHelper.database;
    final rows = await db.rawQuery('$_joinedSelect WHERE rt.id = ?', [id]);
    if (rows.isEmpty) return null;
    return RevenueTransactionModel.fromMap(rows.first);
  }

  Future<DoctorModel> _getDoctorOrThrow(DatabaseExecutor db, int doctorId) async {
    final rows = await db.query(AppConstants.tableDoctors, where: 'id = ?', whereArgs: [doctorId]);
    if (rows.isEmpty) {
      throw ValidationException('Selected doctor does not exist');
    }
    return DoctorModel.fromMap(rows.first);
  }

  @override
  Future<RevenueTransactionModel> create(RevenueTransactionModel transaction) async {
    if (transaction.grossAmount < 0) {
      throw ValidationException('Amount cannot be negative');
    }
    if (transaction.discount < 0 || transaction.discount > transaction.grossAmount) {
      throw ValidationException('Discount cannot exceed the gross amount');
    }

    final db = await _databaseHelper.database;

    return db.transaction<RevenueTransactionModel>((txn) async {
      final doctor = await _getDoctorOrThrow(txn, transaction.doctorId);

      final netAmount = transaction.grossAmount - transaction.discount;
      final (commission, centerShare) = doctor.computeSplit(netAmount);

      final transactionNo = await IdGenerator.nextRevenueNo(txn, transaction.date);

      final toInsert = transaction.copyWith(
        transactionNo: transactionNo,
        netAmount: netAmount,
        doctorCommissionAmount: commission,
        centerShareAmount: centerShare,
      );

      final id = await txn.insert(
        AppConstants.tableRevenueTransactions,
        toInsert.toMap()..remove('id'),
      );

      await _paymentAccountRepository.applyBalanceDelta(
        transaction.paymentMethodId,
        netAmount,
        executor: txn,
      );

      await AuditLogService.record(
        db: txn,
        userId: transaction.createdBy,
        tableName: AppConstants.tableRevenueTransactions,
        recordId: id,
        action: AppConstants.auditInsert,
        newValue: toInsert.toMap(),
      );

      return toInsert.copyWith(id: id);
    });
  }

  @override
  Future<void> update(RevenueTransactionModel transaction) async {
    if (transaction.id == null) {
      throw ValidationException('Cannot update a transaction without an id');
    }
    if (transaction.grossAmount < 0) {
      throw ValidationException('Amount cannot be negative');
    }
    if (transaction.discount < 0 || transaction.discount > transaction.grossAmount) {
      throw ValidationException('Discount cannot exceed the gross amount');
    }

    final db = await _databaseHelper.database;

    await db.transaction((txn) async {
      final beforeRows = await txn
          .query(AppConstants.tableRevenueTransactions, where: 'id = ?', whereArgs: [transaction.id]);
      if (beforeRows.isEmpty) {
        throw NotFoundException('Transaction not found');
      }
      final before = RevenueTransactionModel.fromMap(beforeRows.first);

      // Reverse the old balance effect first.
      await _paymentAccountRepository.applyBalanceDelta(
        before.paymentMethodId,
        -before.netAmount,
        executor: txn,
      );

      final doctor = await _getDoctorOrThrow(txn, transaction.doctorId);
      final netAmount = transaction.grossAmount - transaction.discount;
      final (commission, centerShare) = doctor.computeSplit(netAmount);

      final toUpdate = transaction.copyWith(
        netAmount: netAmount,
        doctorCommissionAmount: commission,
        centerShareAmount: centerShare,
        modifiedAt: DateTime.now(),
      );

      await txn.update(
        AppConstants.tableRevenueTransactions,
        toUpdate.toMap()..remove('id'),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );

      await _paymentAccountRepository.applyBalanceDelta(
        transaction.paymentMethodId,
        netAmount,
        executor: txn,
      );

      await AuditLogService.record(
        db: txn,
        userId: transaction.modifiedBy ?? transaction.createdBy,
        tableName: AppConstants.tableRevenueTransactions,
        recordId: transaction.id!,
        action: AppConstants.auditUpdate,
        oldValue: before.toMap(),
        newValue: toUpdate.toMap(),
      );
    });
  }

  @override
  Future<void> softDelete(int id, {required int userId}) async {
    final db = await _databaseHelper.database;

    await db.transaction((txn) async {
      final rows = await txn
          .query(AppConstants.tableRevenueTransactions, where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) {
        throw NotFoundException('Transaction not found');
      }
      final existing = RevenueTransactionModel.fromMap(rows.first);
      if (existing.isDeleted) return;

      await _paymentAccountRepository.applyBalanceDelta(
        existing.paymentMethodId,
        -existing.netAmount,
        executor: txn,
      );

      await txn.update(
        AppConstants.tableRevenueTransactions,
        {
          'is_deleted': 1,
          'modified_by': userId,
          'modified_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      await AuditLogService.record(
        db: txn,
        userId: userId,
        tableName: AppConstants.tableRevenueTransactions,
        recordId: id,
        action: AppConstants.auditDelete,
        oldValue: existing.toMap(),
      );
    });
  }

  @override
  Future<bool> hasLikelyDuplicate({
    required int? patientId,
    required int doctorId,
    required double grossAmount,
    required DateTime date,
  }) async {
    final db = await _databaseHelper.database;
    final dateStr = date.toIso8601String().split('T').first;
    final conditions = <String>[
      'is_deleted = 0',
      'doctor_id = ?',
      'gross_amount = ?',
      'date = ?',
    ];
    final args = <dynamic>[doctorId, grossAmount, dateStr];
    if (patientId != null) {
      conditions.add('patient_id = ?');
      args.add(patientId);
    }
    final rows = await db.rawQuery(
      'SELECT COUNT(*) as count FROM revenue_transactions WHERE ${conditions.join(' AND ')}',
      args,
    );
    final count = (rows.first['count'] as int?) ?? 0;
    return count > 0;
  }
}
