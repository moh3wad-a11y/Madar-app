import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/password_hasher.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DatabaseHelper _databaseHelper;
  final FlutterSecureStorage _secureStorage;
  static const String _sessionUserIdKey = 'session_user_id';

  AuthRepositoryImpl({
    DatabaseHelper? databaseHelper,
    FlutterSecureStorage? secureStorage,
  })  : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String _userWithRoleQuery = '''
    SELECT users.*, roles.name as role_name
    FROM users
    INNER JOIN roles ON users.role_id = roles.id
  ''';

  @override
  Future<UserModel> login(String username, String password) async {
    final db = await _databaseHelper.database;
    final rows = await db.rawQuery(
      '$_userWithRoleQuery WHERE users.username = ? AND users.is_active = 1',
      [username],
    );

    if (rows.isEmpty) {
      throw AuthException('Incorrect username or password');
    }

    final userMap = rows.first;
    final salt = userMap['salt'] as String;
    final storedHash = userMap['password_hash'] as String;

    if (!PasswordHasher.verifyPassword(password, salt, storedHash)) {
      throw AuthException('Incorrect username or password');
    }

    final user = UserModel.fromMap(userMap, roleName: userMap['role_name'] as String);
    await _secureStorage.write(key: _sessionUserIdKey, value: user.id.toString());
    return user;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final userIdString = await _secureStorage.read(key: _sessionUserIdKey);
    if (userIdString == null) return null;
    final userId = int.tryParse(userIdString);
    if (userId == null) return null;

    final db = await _databaseHelper.database;
    final rows = await db.rawQuery(
      '$_userWithRoleQuery WHERE users.id = ? AND users.is_active = 1',
      [userId],
    );

    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first, roleName: rows.first['role_name'] as String);
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: _sessionUserIdKey);
  }

  @override
  Future<void> changePassword(int userId, String currentPassword, String newPassword) async {
    final db = await _databaseHelper.database;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [userId]);
    if (rows.isEmpty) {
      throw NotFoundException('User not found');
    }
    final existingSalt = rows.first['salt'] as String;
    final existingHash = rows.first['password_hash'] as String;

    if (!PasswordHasher.verifyPassword(currentPassword, existingSalt, existingHash)) {
      throw AuthException('Current password is incorrect');
    }

    final newSalt = PasswordHasher.generateSalt();
    final newHash = PasswordHasher.hashPassword(newPassword, newSalt);

    await db.update(
      'users',
      {'password_hash': newHash, 'salt': newSalt},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<void> resetPassword(int userId, String newPassword) async {
    final db = await _databaseHelper.database;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [userId]);
    if (rows.isEmpty) {
      throw NotFoundException('User not found');
    }
    final newSalt = PasswordHasher.generateSalt();
    final newHash = PasswordHasher.hashPassword(newPassword, newSalt);
    await db.update(
      'users',
      {'password_hash': newHash, 'salt': newSalt},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final db = await _databaseHelper.database;
    final rows = await db.rawQuery('$_userWithRoleQuery ORDER BY users.full_name');
    return rows
        .map((row) => UserModel.fromMap(row, roleName: row['role_name'] as String))
        .toList();
  }

  @override
  Future<UserModel> createUser(UserModel user, String plainPassword) async {
    final db = await _databaseHelper.database;

    final existing = await db.query('users', where: 'username = ?', whereArgs: [user.username]);
    if (existing.isNotEmpty) {
      throw ValidationException('Username already exists');
    }

    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hashPassword(plainPassword, salt);

    final id = await db.insert('users', {
      'username': user.username,
      'password_hash': hash,
      'salt': salt,
      'full_name': user.fullName,
      'role_id': user.roleId,
      'is_active': user.isActive ? 1 : 0,
      'created_at': user.createdAt.toIso8601String(),
    });

    return user.copyWith(id: id, passwordHash: hash, salt: salt);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final db = await _databaseHelper.database;
    await db.update(
      'users',
      {'full_name': user.fullName, 'role_id': user.roleId},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<void> setUserActive(int userId, bool isActive) async {
    final db = await _databaseHelper.database;
    await db.update(
      'users',
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
