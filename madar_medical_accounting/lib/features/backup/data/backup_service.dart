import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/utils/date_formatter.dart';

/// Backup format: a zip containing the raw encrypted SQLCipher database
/// file plus a metadata.json. Every table lives inside that one database
/// file (revenue, expenses, doctors, services, patients, suppliers,
/// payment accounts/methods, settings, users, audit logs) - see section
/// 16 - so backing up the file IS backing up everything, with no risk of
/// breaking foreign keys the way a table-by-table JSON export could.
///
/// SECURITY TRADE-OFF, stated plainly: the database is encrypted with a
/// key that normally never leaves this device's secure storage. For a
/// backup to be restorable on a DIFFERENT phone - the realistic
/// disaster-recovery scenario, since the whole point of a backup is
/// surviving the loss of THIS phone - the backup has to carry that key
/// with it. This implementation stores the key in metadata.json as plain
/// base64. That means anyone who gets the backup .zip can read the
/// entire database. Treat backup files like you'd treat the database
/// itself: store them somewhere you control, never email them or drop
/// them in a shared folder.
class BackupService {
  final DatabaseHelper _databaseHelper;
  final FlutterSecureStorage _secureStorage;
  static const String _encryptionKeyStorageKey = 'madar_db_encryption_key';

  BackupService({
    DatabaseHelper? databaseHelper,
    FlutterSecureStorage? secureStorage,
  })  : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<String> createBackup() async {
    final dbPath = await _databaseHelper.databaseFilePath();
    final dbFile = File(dbPath);
    if (!await dbFile.exists()) {
      throw Exception('No database file found to back up');
    }

    final encryptionKey = await _secureStorage.read(key: _encryptionKeyStorageKey);
    if (encryptionKey == null) {
      throw Exception('Could not read the database encryption key');
    }

    final counts = await _recordCounts();

    final metadata = {
      'app': 'madar_medical_accounting',
      'app_version': '1.0.0',
      'backup_date': DateTime.now().toIso8601String(),
      'db_encryption_key': encryptionKey,
      'record_counts': counts,
    };

    final archive = Archive();
    final dbBytes = await dbFile.readAsBytes();
    archive.addFile(ArchiveFile('madar_accounting.db', dbBytes.length, dbBytes));
    final metadataBytes = utf8.encode(jsonEncode(metadata));
    archive.addFile(ArchiveFile('metadata.json', metadataBytes.length, metadataBytes));

    final zipData = ZipEncoder().encode(archive);
    if (zipData == null) {
      // archive package versions differ on whether encode() can return
      // null; guarding here costs nothing and avoids a silent bad write
      // if it ever does.
      throw Exception('Failed to build the backup archive');
    }

    final outputDir = await getTemporaryDirectory();
    final fileName = 'Madar_Backup_${DateFormatter.toStorage(DateTime.now())}.zip';
    final outputPath = p.join(outputDir.path, fileName);
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(zipData);
    return outputPath;
  }

  Future<Map<String, int>> _recordCounts() async {
    final db = await _databaseHelper.database;
    const tables = [
      'revenue_transactions',
      'expense_transactions',
      'doctors',
      'services',
      'patients',
      'suppliers',
      'users',
    ];
    final counts = <String, int>{};
    for (final table in tables) {
      final rows = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
      counts[table] = (rows.first['count'] as int?) ?? 0;
    }
    return counts;
  }
}
