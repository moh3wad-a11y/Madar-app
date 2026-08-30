import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../audit/data/audit_log_service.dart';
import '../../domain/repositories/expense_category_repository.dart';
import '../models/expense_category_model.dart';

class ExpenseCategoryRepositoryImpl implements ExpenseCategoryRepository {
  final DatabaseHelper _databaseHelper;

  ExpenseCategoryRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<List<ExpenseCategoryModel>> getAll({bool activeOnly = false}) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(
      AppConstants.tableExpenseCategories,
      where: activeOnly ? 'is_active = 1' : null,
      orderBy: 'name',
    );
    return rows.map(ExpenseCategoryModel.fromMap).toList();
  }

  @override
  Future<ExpenseCategoryModel> create(ExpenseCategoryModel category, {required int userId}) async {
    final db = await _databaseHelper.database;
    if (category.name.trim().isEmpty) {
      throw ValidationException('Category name is required');
    }
    final id = await db.insert(AppConstants.tableExpenseCategories, category.toMap()..remove('id'));
    final created = category.copyWith(id: id);
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tableExpenseCategories,
      recordId: id,
      action: AppConstants.auditInsert,
      newValue: created.toMap(),
    );
    return created;
  }

  @override
  Future<void> update(ExpenseCategoryModel category, {required int userId}) async {
    final db = await _databaseHelper.database;
    if (category.id == null) {
      throw ValidationException('Cannot update a category without an id');
    }
    await db.update(
      AppConstants.tableExpenseCategories,
      category.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [category.id],
    );
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tableExpenseCategories,
      recordId: category.id!,
      action: AppConstants.auditUpdate,
      newValue: category.toMap(),
    );
  }

  @override
  Future<void> setActive(int id, bool isActive, {required int userId}) async {
    final db = await _databaseHelper.database;
    await db.update(
      AppConstants.tableExpenseCategories,
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tableExpenseCategories,
      recordId: id,
      action: AppConstants.auditUpdate,
      newValue: {'is_active': isActive},
    );
  }
}
