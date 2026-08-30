import 'package:sqflite_sqlcipher/sqflite.dart';
import '../constants/app_constants.dart';
import '../utils/password_hasher.dart';

/// Populates a freshly created database with the minimum data the app
/// needs to be usable on first launch: the four roles, one Owner login,
/// the default expense categories, and the payment accounts/methods.
///
/// IMPORTANT: the seeded admin password is intentionally simple
/// ('admin123') and MUST be changed on first login in a real deployment.
/// The login screen and Settings > Users screen both support changing it.
class SeedData {
  SeedData._();

  static Future<void> seedAll(Database db) async {
    await _seedRoles(db);
    await _seedAdminUser(db);
    await _seedExpenseCategories(db);
    await _seedPaymentAccountsAndMethods(db);
    await _seedSettings(db);
  }

  static Future<void> _seedRoles(Database db) async {
    final roles = [
      {'name': AppConstants.roleOwner, 'name_ar': 'مالك', 'description': 'Full access to every module'},
      {
        'name': AppConstants.roleAccountant,
        'name_ar': 'محاسب',
        'description': 'Revenue, expenses, and reports',
      },
      {
        'name': AppConstants.roleReception,
        'name_ar': 'استقبال',
        'description': 'Revenue entry only',
      },
      {'name': AppConstants.roleViewer, 'name_ar': 'مشاهد', 'description': 'Reports only'},
    ];
    for (final role in roles) {
      await db.insert('roles', role);
    }
  }

  static Future<void> _seedAdminUser(Database db) async {
    final ownerRole = await db.query('roles', where: 'name = ?', whereArgs: [AppConstants.roleOwner]);
    final ownerRoleId = ownerRole.first['id'] as int;

    const plainPassword = 'admin123';
    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hashPassword(plainPassword, salt);

    await db.insert('users', {
      'username': 'admin',
      'password_hash': hash,
      'salt': salt,
      'full_name': 'Center Owner',
      'role_id': ownerRoleId,
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> _seedExpenseCategories(Database db) async {
    for (final category in AppConstants.defaultExpenseCategories) {
      await db.insert('expense_categories', {
        'name': category['name'],
        'name_ar': category['name_ar'],
        'is_active': 1,
      });
    }
  }

  static Future<void> _seedPaymentAccountsAndMethods(Database db) async {
    for (final entry in AppConstants.defaultPaymentAccounts) {
      final accountId = await db.insert('payment_accounts', {
        'name': entry['account'],
        'account_type': entry['type'],
        'opening_balance': 0.0,
        'current_balance': 0.0,
      });
      await db.insert('payment_methods', {
        'name': entry['method'],
        'payment_account_id': accountId,
        'is_active': 1,
      });
    }
  }

  static Future<void> _seedSettings(Database db) async {
    final defaults = {
      AppConstants.settingCurrency: AppConstants.defaultCurrency,
      AppConstants.settingLocale: 'ar',
      AppConstants.settingClinicName: AppConstants.appNameAr,
    };
    for (final entry in defaults.entries) {
      await db.insert('settings', {'key': entry.key, 'value': entry.value});
    }
  }
}
