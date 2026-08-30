import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../audit/data/audit_log_service.dart';
import '../../domain/repositories/service_repository.dart';
import '../models/service_model.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final DatabaseHelper _databaseHelper;

  ServiceRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<List<ServiceModel>> getAll({bool activeOnly = false}) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(
      AppConstants.tableServices,
      where: activeOnly ? 'is_active = 1' : null,
      orderBy: 'name',
    );
    return rows.map(ServiceModel.fromMap).toList();
  }

  @override
  Future<ServiceModel?> getById(int id) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(AppConstants.tableServices, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return ServiceModel.fromMap(rows.first);
  }

  @override
  Future<ServiceModel> create(ServiceModel service, {required int userId}) async {
    final db = await _databaseHelper.database;
    if (service.name.trim().isEmpty) {
      throw ValidationException('Service name is required');
    }
    if (service.price < 0) {
      throw ValidationException('Service price cannot be negative');
    }
    final id = await db.insert(AppConstants.tableServices, service.toMap()..remove('id'));
    final created = service.copyWith(id: id);
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tableServices,
      recordId: id,
      action: AppConstants.auditInsert,
      newValue: created.toMap(),
    );
    return created;
  }

  @override
  Future<void> update(ServiceModel service, {required int userId}) async {
    final db = await _databaseHelper.database;
    if (service.id == null) {
      throw ValidationException('Cannot update a service without an id');
    }
    if (service.price < 0) {
      throw ValidationException('Service price cannot be negative');
    }
    final before = await getById(service.id!);
    await db.update(
      AppConstants.tableServices,
      service.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [service.id],
    );
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tableServices,
      recordId: service.id!,
      action: AppConstants.auditUpdate,
      oldValue: before?.toMap(),
      newValue: service.toMap(),
    );
  }

  @override
  Future<void> setActive(int id, bool isActive, {required int userId}) async {
    final db = await _databaseHelper.database;
    final before = await getById(id);
    await db.update(
      AppConstants.tableServices,
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tableServices,
      recordId: id,
      action: AppConstants.auditUpdate,
      oldValue: before?.toMap(),
      newValue: {'is_active': isActive},
    );
  }
}
