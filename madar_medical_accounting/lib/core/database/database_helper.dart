import 'dart:io';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'db_schema.dart';
import 'seed_data.dart';

/// Singleton wrapper around the encrypted SQLite database.
///
/// The database file itself is encrypted at rest with SQLCipher. The
/// encryption key is generated once with a cryptographically secure
/// random source and stored in flutter_secure_storage, which is backed
/// by the Android Keystore. The key is intentionally NOT derived from
/// any individual user's login password - multiple users with different,
/// changeable passwords share one database, so tying the encryption key
/// to a specific user's password would make the database unrecoverable
/// the moment that user changes or forgets it.
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const String _dbName = 'madar_accounting.db';
  static const int _dbVersion = 1;
  static const String _encryptionKeyStorageKey = 'madar_db_encryption_key';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<String> _getOrCreateEncryptionKey() async {
    String? key = await _secureStorage.read(key: _encryptionKeyStorageKey);
    if (key == null) {
      key = _generateRandomKey();
      await _secureStorage.write(key: _encryptionKeyStorageKey, value: key);
    }
    return key;
  }

  String _generateRandomKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Future<Database> _initDatabase() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _dbName);
    final String encryptionKey = await _getOrCreateEncryptionKey();

    return openDatabase(
      path,
      version: _dbVersion,
      password: encryptionKey,
      onCreate: (db, version) async {
        await DbSchema.createAll(db);
        await SeedData.seedAll(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Future schema migrations are added here, guarded by
        // `if (oldVersion < N) { ... }` blocks - never drop tables.
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// Exposed for the backup module (Phase 5), which needs the raw file
  /// path to copy/zip the encrypted database.
  Future<String> databaseFilePath() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, _dbName);
  }
}
