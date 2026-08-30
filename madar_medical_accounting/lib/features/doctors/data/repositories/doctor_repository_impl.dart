import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../audit/data/audit_log_service.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../models/doctor_model.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DatabaseHelper _databaseHelper;

  DoctorRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<List<DoctorModel>> getAll({bool activeOnly = false}) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(
      AppConstants.tableDoctors,
      where: activeOnly ? 'is_active = 1' : null,
      orderBy: 'name',
    );
    return rows.map(DoctorModel.fromMap).toList();
  }

  @override
  Future<DoctorModel?> getById(int id) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(AppConstants.tableDoctors, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return DoctorModel.fromMap(rows.first);
  }

  @override
  Future<DoctorModel> create(DoctorModel doctor, {required int userId}) async {
    final db = await _databaseHelper.database;
    if (doctor.name.trim().isEmpty) {
      throw ValidationException('Doctor name is required');
    }
    final id = await db.insert(AppConstants.tableDoctors, doctor.toMap()..remove('id'));
    final created = doctor.copyWith(id: id);
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tableDoctors,
      recordId: id,
      action: AppConstants.auditInsert,
      newValue: created.toMap(),
    );
    return created;
  }

  @override
  Future<void> update(DoctorModel doctor, {required int userId}) async {
    final db = await _databaseHelper.database;
    if (doctor.id == null) {
      throw ValidationException('Cannot update a doctor without an id');
    }
    final before = await getById(doctor.id!);
    await db.update(
      AppConstants.tableDoctors,
      doctor.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [doctor.id],
    );
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tableDoctors,
      recordId: doctor.id!,
      action: AppConstants.auditUpdate,
      oldValue: before?.toMap(),
      newValue: doctor.toMap(),
    );
  }

  @override
  Future<void> setActive(int id, bool isActive, {required int userId}) async {
    final db = await _databaseHelper.database;
    final before = await getById(id);
    await db.update(
      AppConstants.tableDoctors,
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tableDoctors,
      recordId: id,
      action: AppConstants.auditUpdate,
      oldValue: before?.toMap(),
      newValue: {'is_active': isActive},
    );
  }
}
