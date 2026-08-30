import 'package:sqflite_sqlcipher/sqflite.dart';

/// Full DDL for the Madar Medical Center Accounting database.
/// Every CREATE TABLE / CREATE INDEX statement lives here so the schema
/// is reviewable in one place and onUpgrade() migrations have a single
/// source of truth to diff against.
class DbSchema {
  DbSchema._();

  static Future<void> createAll(Database db) async {
    await db.execute('''
      CREATE TABLE roles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        name_ar TEXT NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        salt TEXT NOT NULL,
        full_name TEXT NOT NULL,
        role_id INTEGER NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        FOREIGN KEY (role_id) REFERENCES roles (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE doctors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        specialty TEXT,
        phone TEXT,
        commission_type TEXT NOT NULL DEFAULT 'none',
        commission_value REAL NOT NULL DEFAULT 0,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE services (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT,
        price REAL NOT NULL DEFAULT 0,
        doctor_id INTEGER,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        FOREIGN KEY (doctor_id) REFERENCES doctors (id) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        gender TEXT,
        date_of_birth TEXT,
        notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE suppliers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        tax_id TEXT,
        notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE payment_accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        account_type TEXT NOT NULL,
        opening_balance REAL NOT NULL DEFAULT 0,
        current_balance REAL NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE payment_methods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        payment_account_id INTEGER NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (payment_account_id) REFERENCES payment_accounts (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE expense_categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        name_ar TEXT,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE revenue_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_no TEXT NOT NULL UNIQUE,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        patient_id INTEGER,
        doctor_id INTEGER NOT NULL,
        service_id INTEGER NOT NULL,
        gross_amount REAL NOT NULL,
        discount REAL NOT NULL DEFAULT 0,
        net_amount REAL NOT NULL,
        payment_method_id INTEGER NOT NULL,
        doctor_commission_amount REAL NOT NULL DEFAULT 0,
        center_share_amount REAL NOT NULL DEFAULT 0,
        notes TEXT,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        created_by INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        modified_by INTEGER,
        modified_at TEXT,
        FOREIGN KEY (patient_id) REFERENCES patients (id),
        FOREIGN KEY (doctor_id) REFERENCES doctors (id),
        FOREIGN KEY (service_id) REFERENCES services (id),
        FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id),
        FOREIGN KEY (created_by) REFERENCES users (id),
        FOREIGN KEY (modified_by) REFERENCES users (id)
      )
    ''');
    await db.execute('CREATE INDEX idx_revenue_date ON revenue_transactions (date)');
    await db.execute('CREATE INDEX idx_revenue_doctor ON revenue_transactions (doctor_id)');
    await db.execute(
        'CREATE INDEX idx_revenue_payment_method ON revenue_transactions (payment_method_id)');
    await db.execute('CREATE INDEX idx_revenue_service ON revenue_transactions (service_id)');

    await db.execute('''
      CREATE TABLE expense_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expense_no TEXT NOT NULL UNIQUE,
        date TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        supplier_id INTEGER,
        description TEXT,
        amount REAL NOT NULL,
        payment_method_id INTEGER NOT NULL,
        invoice_number TEXT,
        attachment_path TEXT,
        notes TEXT,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        created_by INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        modified_by INTEGER,
        modified_at TEXT,
        FOREIGN KEY (category_id) REFERENCES expense_categories (id),
        FOREIGN KEY (supplier_id) REFERENCES suppliers (id),
        FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id),
        FOREIGN KEY (created_by) REFERENCES users (id),
        FOREIGN KEY (modified_by) REFERENCES users (id)
      )
    ''');
    await db.execute('CREATE INDEX idx_expense_date ON expense_transactions (date)');
    await db.execute('CREATE INDEX idx_expense_category ON expense_transactions (category_id)');

    await db.execute('''
      CREATE TABLE audit_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        table_name TEXT NOT NULL,
        record_id INTEGER NOT NULL,
        action TEXT NOT NULL,
        old_value TEXT,
        new_value TEXT,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
    await db.execute('CREATE INDEX idx_audit_table_record ON audit_logs (table_name, record_id)');

    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }
}
