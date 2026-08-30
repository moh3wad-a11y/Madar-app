import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/database/database_helper.dart';

class BackupMetadata {
  final String appVersion;
  final DateTime backupDate;
  final Map<String, int> recordCounts;

  const BackupMetadata({
    required this.appVersion,
    required this.backupDate,
    required this.recordCounts,
  });
}

class RestoreService {
  final DatabaseHelper _databaseHelper;
  final FlutterSecureStorage _secureStorage;
  static const String _encryptionKeyStorageKey = 'madar_db_encryption_key';

  RestoreService({
    DatabaseHelper? databaseHelper,
    FlutterSecureStorage? secureStorage,
  })  : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Reads the backup zip and returns its metadata WITHOUT touching the
  /// live database - lets the UI show "this backup has 214 revenue
  /// transactions from 12/08/2026" before the user commits to the
  /// destructive restore step.
  Future<BackupMetadata> inspectBackup(String zipFilePath) async {
    final archive = await _readArchive(zipFilePath);
    final metadataFile = archive.findFile('metadata.json');
    if (metadataFile == null) {
      throw Exception('This does not look like a Madar backup file (missing metadata.json)');
    }
    final metadataJson =
        jsonDecode(utf8.decode(metadataFile.content as List<int>)) as Map<String, dynamic>;
    if (metadataJson['app'] != 'madar_medical_accounting') {
      throw Exception('This backup file is not from Madar Medical Center Accounting');
    }
    final rawCounts = Map<String, dynamic>.from(metadataJson['record_counts'] as Map);
    return BackupMetadata(
      appVersion: metadataJson['app_version'] as String? ?? 'unknown',
      backupDate: DateTime.parse(metadataJson['backup_date'] as String),
      recordCounts: rawCounts.map((k, v) => MapEntry(k, v as int)),
    );
  }

  /// Destructive: replaces the entire current database with the one in
  /// the backup. Callers must confirm with the user first (see
  /// inspectBackup for the preview data to show them) and must trigger a
  /// full app restart afterward - see RestartWidget - since every
  /// Riverpod provider that has ever cached a query result is now
  /// holding data from a file that no longer exists.
  Future<void> restoreFromBackup(String zipFilePath) async {
    final archive = await _readArchive(zipFilePath);

    final metadataFile = archive.findFile('metadata.json');
    final dbFileEntry = archive.findFile('madar_accounting.db');
    if (metadataFile == null || dbFileEntry == null) {
      throw Exception('This backup file is incomplete or corrupted');
    }

    final metadataJson =
        jsonDecode(utf8.decode(metadataFile.content as List<int>)) as Map<String, dynamic>;
    final backupKey = metadataJson['db_encryption_key'] as String?;
    if (backupKey == null) {
      throw Exception('This backup file is missing its database key and cannot be restored');
    }

    // Close the live connection before touching the file on disk -
    // SQLCipher will not tolerate the underlying file changing out from
    // under an open connection.
    await _databaseHelper.close();

    final dbPath = await _databaseHelper.databaseFilePath();
    final dbFile = File(dbPath);
    await dbFile.writeAsBytes(dbFileEntry.content as List<int>);

    // The restored file was encrypted with the BACKUP's key, not this
    // install's key - secure storage must be updated to match, or the
    // next open() call fails with the wrong password.
    await _secureStorage.write(key: _encryptionKeyStorageKey, value: backupKey);
  }

  Future<Archive> _readArchive(String zipFilePath) async {
    final bytes = await File(zipFilePath).readAsBytes();
    return ZipDecoder().decodeBytes(bytes);
  }
}
