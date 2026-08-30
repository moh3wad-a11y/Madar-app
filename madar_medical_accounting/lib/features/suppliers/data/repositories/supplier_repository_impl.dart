import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../audit/data/audit_log_service.dart';
import '../../domain/repositories/supplier_repository.dart';
import '../models/supplier_model.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final DatabaseHelper _databaseHelper;

  SupplierRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<List<SupplierModel>> getAll({String? searchQuery}) async {
    final db = await _databaseHelper.database;
    final hasQuery = searchQuery != null && searchQuery.trim().isNotEmpty;
    final rows = await db.query(
      AppConstants.tableSuppliers,
      where: hasQuery ? 'name LIKE ?' : null,
      whereArgs: hasQuery ? ['%${searchQuery.trim()}%'] : null,
      orderBy: 'name',
    );
    return rows.map(SupplierModel.fromMap).toList();
  }

  @override
  Future<SupplierModel?> getById(int id) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(AppConstants.tableSuppliers, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return SupplierModel.fromMap(rows.first);
  }

  @override
  Future<SupplierModel> create(SupplierModel supplier, {required int userId}) async {
    final db = await _databaseHelper.database;
    if (supplier.name.trim().isEmpty) {
      throw ValidationException('Supplier name is required');
    }
    final id = await db.insert(AppConstants.tableSuppliers, supplier.toMap()..remove('id'));
    final created = supplier.copyWith(id: id);
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tableSuppliers,
      recordId: id,
      action: AppConstants.auditInsert,
      newValue: created.toMap(),
    );
    return created;
  }

  @override
  Future<void> update(SupplierModel supplier, {required int userId}) async {
    final db = await _databaseHelper.database;
    if (supplier.id == null) {
      throw ValidationException('Cannot update a supplier without an id');
    }
    final before = await getById(supplier.id!);
    await db.update(
      AppConstants.tableSuppliers,
      supplier.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [supplier.id],
    );
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tableSuppliers,
      recordId: supplier.id!,
      action: AppConstants.auditUpdate,
      oldValue: before?.toMap(),
      newValue: supplier.toMap(),
    );
  }
}
