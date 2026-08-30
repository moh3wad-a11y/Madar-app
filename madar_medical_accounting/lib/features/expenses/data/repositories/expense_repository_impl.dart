import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../audit/data/audit_log_service.dart';
import '../../../payment_accounts/data/repositories/payment_account_repository_impl.dart';
import '../../domain/repositories/expense_repository.dart';
import '../models/expense_transaction_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final DatabaseHelper _databaseHelper;
  final PaymentAccountRepositoryImpl _paymentAccountRepository;

  ExpenseRepositoryImpl({
    DatabaseHelper? databaseHelper,
    PaymentAccountRepositoryImpl? paymentAccountRepository,
  })  : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
        _paymentAccountRepository = paymentAccountRepository ?? PaymentAccountRepositoryImpl();

  static const String _joinedSelect = '''
    SELECT et.*,
           ec.name as category_name,
           sup.name as supplier_name,
           pm.name as payment_method_name
    FROM expense_transactions et
    INNER JOIN expense_categories ec ON et.category_id = ec.id
    LEFT JOIN suppliers sup ON et.supplier_id = sup.id
    INNER JOIN payment_methods pm ON et.payment_method_id = pm.id
  ''';

  @override
  Future<List<ExpenseTransactionModel>> getAll(ExpenseFilter filter) async {
    final db = await _databaseHelper.database;
    final conditions = <String>['et.is_deleted = 0'];
    final args = <dynamic>[];

    if (filter.dateRange != null) {
      conditions.add('et.date >= ? AND et.date <= ?');
      args.add(filter.dateRange!.start.toIso8601String().split('T').first);
      args.add(filter.dateRange!.end.toIso8601String().split('T').first);
    }
    if (filter.categoryId != null) {
      conditions.add('et.category_id = ?');
      args.add(filter.categoryId);
    }
    if (filter.supplierId != null) {
      conditions.add('et.supplier_id = ?');
      args.add(filter.supplierId);
    }
    if (filter.paymentMethodId != null) {
      conditions.add('et.payment_method_id = ?');
      args.add(filter.paymentMethodId);
    }
    if (filter.searchQuery != null && filter.searchQuery!.trim().isNotEmpty) {
      conditions.add('(et.description LIKE ? OR et.expense_no LIKE ?)');
      final q = '%${filter.searchQuery!.trim()}%';
      args.addAll([q, q]);
    }

    final rows = await db.rawQuery(
      '$_joinedSelect WHERE ${conditions.join(' AND ')} ORDER BY et.date DESC, et.id DESC',
      args,
    );
    return rows.map(ExpenseTransactionModel.fromMap).toList();
  }

  @override
  Future<ExpenseTransactionModel?> getById(int id) async {
    final db = await _databaseHelper.database;
    final rows = await db.rawQuery('$_joinedSelect WHERE et.id = ?', [id]);
    if (rows.isEmpty) return null;
    return ExpenseTransactionModel.fromMap(rows.first);
  }

  @override
  Future<ExpenseTransactionModel> create(ExpenseTransactionModel expense) async {
    if (expense.amount < 0) {
      throw ValidationException('Amount cannot be negative');
    }
    final db = await _databaseHelper.database;

    return db.transaction<ExpenseTransactionModel>((txn) async {
      final categoryRows = await txn
          .query(AppConstants.tableExpenseCategories, where: 'id = ?', whereArgs: [expense.categoryId]);
      if (categoryRows.isEmpty) {
        throw ValidationException('Selected expense category does not exist');
      }

      final expenseNo = await IdGenerator.nextExpenseNo(txn, expense.date);
      final toInsert = expense.copyWith(expenseNo: expenseNo);

      final id = await txn.insert(
        AppConstants.tableExpenseTransactions,
        toInsert.toMap()..remove('id'),
      );

      await _paymentAccountRepository.applyBalanceDelta(
        expense.paymentMethodId,
        -expense.amount,
        executor: txn,
      );

      await AuditLogService.record(
        db: txn,
        userId: expense.createdBy,
        tableName: AppConstants.tableExpenseTransactions,
        recordId: id,
        action: AppConstants.auditInsert,
        newValue: toInsert.toMap(),
      );

      return toInsert.copyWith(id: id);
    });
  }

  @override
  Future<void> update(ExpenseTransactionModel expense) async {
    if (expense.id == null) {
      throw ValidationException('Cannot update an expense without an id');
    }
    if (expense.amount < 0) {
      throw ValidationException('Amount cannot be negative');
    }

    final db = await _databaseHelper.database;

    await db.transaction((txn) async {
      final beforeRows = await txn
          .query(AppConstants.tableExpenseTransactions, where: 'id = ?', whereArgs: [expense.id]);
      if (beforeRows.isEmpty) {
        throw NotFoundException('Expense not found');
      }
      final before = ExpenseTransactionModel.fromMap(beforeRows.first);

      await _paymentAccountRepository.applyBalanceDelta(
        before.paymentMethodId,
        before.amount,
        executor: txn,
      );

      final toUpdate = expense.copyWith(modifiedAt: DateTime.now());

      await txn.update(
        AppConstants.tableExpenseTransactions,
        toUpdate.toMap()..remove('id'),
        where: 'id = ?',
        whereArgs: [expense.id],
      );

      await _paymentAccountRepository.applyBalanceDelta(
        expense.paymentMethodId,
        -expense.amount,
        executor: txn,
      );

      await AuditLogService.record(
        db: txn,
        userId: expense.modifiedBy ?? expense.createdBy,
        tableName: AppConstants.tableExpenseTransactions,
        recordId: expense.id!,
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
          .query(AppConstants.tableExpenseTransactions, where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) {
        throw NotFoundException('Expense not found');
      }
      final existing = ExpenseTransactionModel.fromMap(rows.first);
      if (existing.isDeleted) return;

      await _paymentAccountRepository.applyBalanceDelta(
        existing.paymentMethodId,
        existing.amount,
        executor: txn,
      );

      await txn.update(
        AppConstants.tableExpenseTransactions,
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
        tableName: AppConstants.tableExpenseTransactions,
        recordId: id,
        action: AppConstants.auditDelete,
        oldValue: existing.toMap(),
      );
    });
  }
}
