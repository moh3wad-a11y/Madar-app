import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../audit/data/audit_log_service.dart';
import '../../domain/repositories/payment_account_repository.dart';
import '../models/payment_account_model.dart';
import '../models/payment_method_model.dart';

class PaymentAccountRepositoryImpl implements PaymentAccountRepository {
  final DatabaseHelper _databaseHelper;

  PaymentAccountRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<List<PaymentAccountModel>> getAllAccounts() async {
    final db = await _databaseHelper.database;
    final rows = await db.query(AppConstants.tablePaymentAccounts, orderBy: 'id');
    return rows.map(PaymentAccountModel.fromMap).toList();
  }

  @override
  Future<PaymentAccountModel?> getAccountById(int id) async {
    final db = await _databaseHelper.database;
    final rows =
        await db.query(AppConstants.tablePaymentAccounts, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return PaymentAccountModel.fromMap(rows.first);
  }

  @override
  Future<List<PaymentMethodModel>> getAllMethods({bool activeOnly = false}) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(
      AppConstants.tablePaymentMethods,
      where: activeOnly ? 'is_active = 1' : null,
      orderBy: 'id',
    );
    return rows.map(PaymentMethodModel.fromMap).toList();
  }

  @override
  Future<PaymentMethodModel?> getMethodById(int id) async {
    final db = await _databaseHelper.database;
    final rows =
        await db.query(AppConstants.tablePaymentMethods, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return PaymentMethodModel.fromMap(rows.first);
  }

  @override
  Future<void> applyBalanceDelta(
    int paymentMethodId,
    double delta, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _databaseHelper.database;

    final methodRows = await db
        .query(AppConstants.tablePaymentMethods, where: 'id = ?', whereArgs: [paymentMethodId]);
    if (methodRows.isEmpty) {
      throw NotFoundException('Payment method not found');
    }
    final accountId = methodRows.first['payment_account_id'] as int;

    await db.rawUpdate(
      'UPDATE ${AppConstants.tablePaymentAccounts} SET current_balance = current_balance + ? WHERE id = ?',
      [delta, accountId],
    );
  }

  @override
  Future<void> createMethod(PaymentMethodModel method, {required int userId}) async {
    final db = await _databaseHelper.database;
    if (method.name.trim().isEmpty) {
      throw ValidationException('Payment method name is required');
    }
    final id = await db.insert(AppConstants.tablePaymentMethods, method.toMap()..remove('id'));
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tablePaymentMethods,
      recordId: id,
      action: AppConstants.auditInsert,
      newValue: method.copyWith(id: id).toMap(),
    );
  }

  @override
  Future<void> setMethodActive(int id, bool isActive, {required int userId}) async {
    final db = await _databaseHelper.database;
    await db.update(
      AppConstants.tablePaymentMethods,
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tablePaymentMethods,
      recordId: id,
      action: AppConstants.auditUpdate,
      newValue: {'is_active': isActive},
    );
  }
}
