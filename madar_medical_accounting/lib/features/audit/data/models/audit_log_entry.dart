class AuditLogEntry {
  final int id;
  final int? userId;
  final String? userName;
  final String tableName;
  final int recordId;
  final String action;
  final String? oldValue;
  final String? newValue;
  final DateTime timestamp;

  const AuditLogEntry({
    required this.id,
    this.userId,
    this.userName,
    required this.tableName,
    required this.recordId,
    required this.action,
    this.oldValue,
    this.newValue,
    required this.timestamp,
  });

  factory AuditLogEntry.fromMap(Map<String, dynamic> map) {
    return AuditLogEntry(
      id: map['id'] as int,
      userId: map['user_id'] as int?,
      userName: map['user_name'] as String?,
      tableName: map['table_name'] as String,
      recordId: map['record_id'] as int,
      action: map['action'] as String,
      oldValue: map['old_value'] as String?,
      newValue: map['new_value'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  String get friendlyTableName {
    switch (tableName) {
      case 'revenue_transactions':
        return 'Revenue';
      case 'expense_transactions':
        return 'Expense';
      case 'doctors':
        return 'Doctor';
      case 'services':
        return 'Service';
      case 'patients':
        return 'Patient';
      case 'suppliers':
        return 'Supplier';
      case 'expense_categories':
        return 'Expense category';
      case 'payment_methods':
        return 'Payment method';
      case 'users':
        return 'User';
      default:
        return tableName;
    }
  }
}
