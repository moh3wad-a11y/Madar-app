import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../audit/data/audit_log_service.dart';
import '../../domain/repositories/patient_repository.dart';
import '../models/patient_model.dart';

class PatientRepositoryImpl implements PatientRepository {
  final DatabaseHelper _databaseHelper;

  PatientRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<List<PatientModel>> getAll({String? searchQuery}) async {
    final db = await _databaseHelper.database;
    final hasQuery = searchQuery != null && searchQuery.trim().isNotEmpty;
    final rows = await db.query(
      AppConstants.tablePatients,
      where: hasQuery ? '(name LIKE ? OR phone LIKE ?)' : null,
      whereArgs: hasQuery ? ['%${searchQuery.trim()}%', '%${searchQuery.trim()}%'] : null,
      orderBy: 'name',
    );
    return rows.map(PatientModel.fromMap).toList();
  }

  @override
  Future<PatientModel?> getById(int id) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(AppConstants.tablePatients, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return PatientModel.fromMap(rows.first);
  }

  @override
  Future<PatientModel> create(PatientModel patient, {required int userId}) async {
    final db = await _databaseHelper.database;
    if (patient.name.trim().isEmpty) {
      throw ValidationException('Patient name is required');
    }
    final id = await db.insert(AppConstants.tablePatients, patient.toMap()..remove('id'));
    final created = patient.copyWith(id: id);
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tablePatients,
      recordId: id,
      action: AppConstants.auditInsert,
      newValue: created.toMap(),
    );
    return created;
  }

  @override
  Future<void> update(PatientModel patient, {required int userId}) async {
    final db = await _databaseHelper.database;
    if (patient.id == null) {
      throw ValidationException('Cannot update a patient without an id');
    }
    final before = await getById(patient.id!);
    await db.update(
      AppConstants.tablePatients,
      patient.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [patient.id],
    );
    await AuditLogService.record(
      db: db,
      userId: userId,
      tableName: AppConstants.tablePatients,
      recordId: patient.id!,
      action: AppConstants.auditUpdate,
      oldValue: before?.toMap(),
      newValue: patient.toMap(),
    );
  }
}
