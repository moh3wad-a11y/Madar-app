class AppConstants {
  AppConstants._();

  static const String appName = 'Madar Medical Center Accounting';
  static const String appNameAr = 'مدار - حسابات المركز الطبي';

  static const String defaultCurrency = 'EGP';
  static const String dateStorageFormat = 'yyyy-MM-dd';
  static const String dateDisplayFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';

  // Table names
  static const String tableRoles = 'roles';
  static const String tableUsers = 'users';
  static const String tableDoctors = 'doctors';
  static const String tableServices = 'services';
  static const String tablePatients = 'patients';
  static const String tableSuppliers = 'suppliers';
  static const String tablePaymentAccounts = 'payment_accounts';
  static const String tablePaymentMethods = 'payment_methods';
  static const String tableExpenseCategories = 'expense_categories';
  static const String tableRevenueTransactions = 'revenue_transactions';
  static const String tableExpenseTransactions = 'expense_transactions';
  static const String tableAuditLogs = 'audit_logs';
  static const String tableSettings = 'settings';

  // Roles (must match seeded rows in roles table)
  static const String roleOwner = 'Owner';
  static const String roleAccountant = 'Accountant';
  static const String roleReception = 'Reception';
  static const String roleViewer = 'Viewer';

  // Doctor commission types
  static const String commissionPercentage = 'percentage';
  static const String commissionFixed = 'fixed';
  static const String commissionNone = 'none';

  // Payment account types
  static const String accountTypeCash = 'cash';
  static const String accountTypeBank = 'bank';
  static const String accountTypeVisa = 'visa';
  static const String accountTypeMastercard = 'mastercard';
  static const String accountTypeInstapay = 'instapay';
  static const String accountTypeOther = 'other';

  // Audit actions
  static const String auditInsert = 'insert';
  static const String auditUpdate = 'update';
  static const String auditDelete = 'delete';

  // Settings keys
  static const String settingCurrency = 'currency';
  static const String settingLocale = 'locale';
  static const String settingClinicName = 'clinic_name';

  // Default expense categories (name, name_ar)
  static const List<Map<String, String>> defaultExpenseCategories = [
    {'name': 'Salaries', 'name_ar': 'الرواتب'},
    {'name': 'Rent', 'name_ar': 'الإيجار'},
    {'name': 'Electricity', 'name_ar': 'الكهرباء'},
    {'name': 'Water', 'name_ar': 'المياه'},
    {'name': 'Internet', 'name_ar': 'الإنترنت'},
    {'name': 'Medical Supplies', 'name_ar': 'مستلزمات طبية'},
    {'name': 'Medicines', 'name_ar': 'أدوية'},
    {'name': 'Cleaning', 'name_ar': 'النظافة'},
    {'name': 'Maintenance', 'name_ar': 'الصيانة'},
    {'name': 'Marketing', 'name_ar': 'التسويق'},
    {'name': 'Transportation', 'name_ar': 'المواصلات'},
    {'name': 'Professional Fees', 'name_ar': 'أتعاب مهنية'},
    {'name': 'Bank Charges', 'name_ar': 'مصاريف بنكية'},
    {'name': 'Taxes', 'name_ar': 'ضرائب'},
    {'name': 'Insurance', 'name_ar': 'تأمين'},
    {'name': 'Other', 'name_ar': 'أخرى'},
  ];

  // Default payment accounts and the payment method that posts to each
  // (account name, account type, method name)
  static const List<Map<String, String>> defaultPaymentAccounts = [
    {'account': 'Cash', 'type': accountTypeCash, 'method': 'Cash'},
    {'account': 'Bank', 'type': accountTypeBank, 'method': 'Bank Transfer'},
    {'account': 'Visa', 'type': accountTypeVisa, 'method': 'Visa'},
    {'account': 'Mastercard', 'type': accountTypeMastercard, 'method': 'Mastercard'},
    {'account': 'InstaPay', 'type': accountTypeInstapay, 'method': 'InstaPay'},
    {'account': 'Other', 'type': accountTypeOther, 'method': 'Other'},
  ];
}
