// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Madar Medical Center Accounting';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navRevenue => 'Revenue';

  @override
  String get navExpenses => 'Expenses';

  @override
  String get navReports => 'Reports';

  @override
  String get navMore => 'More';

  @override
  String get navDoctors => 'Doctors';

  @override
  String get navServices => 'Services';

  @override
  String get navPatients => 'Patients';

  @override
  String get navSuppliers => 'Suppliers';

  @override
  String get navPaymentAccounts => 'Payment accounts';

  @override
  String get navSettings => 'Settings';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginWelcome => 'Welcome back';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get invalidCredentials => 'Incorrect username or password';

  @override
  String get logout => 'Log out';

  @override
  String get defaultLoginHint =>
      'Default owner login: admin / admin123 - change this immediately after first sign-in.';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get notes => 'Notes';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get phoneOptional => 'Phone (optional)';

  @override
  String get amount => 'Amount';

  @override
  String get total => 'Total';

  @override
  String get close => 'Close';

  @override
  String get filterAllTime => 'All time';

  @override
  String get filterToday => 'Today';

  @override
  String get filterYesterday => 'Yesterday';

  @override
  String get filterThisWeek => 'This week';

  @override
  String get filterThisMonth => 'This month';

  @override
  String get filterLastMonth => 'Last month';

  @override
  String get filterThisYear => 'This year';

  @override
  String get filterCustomRange => 'Custom range';

  @override
  String get filterCustom => 'Custom';

  @override
  String get fromDate => 'From';

  @override
  String get toDate => 'To';

  @override
  String get todayLabel => 'Today';

  @override
  String get todayRevenue => 'Today\'s revenue';

  @override
  String get todayExpenses => 'Today\'s expenses';

  @override
  String get todayNetProfit => 'Today\'s net profit';

  @override
  String get cashBalance => 'Cash balance';

  @override
  String get selectedPeriod => 'Selected period';

  @override
  String get monthlyRevenue => 'Revenue';

  @override
  String get monthlyExpenses => 'Expenses';

  @override
  String get monthlyNetProfit => 'Net profit';

  @override
  String get transactionCount => 'Transactions';

  @override
  String get chartRevenueVsExpenses => 'Revenue vs expenses';

  @override
  String get chartRevenueByDoctor => 'Revenue by doctor';

  @override
  String get chartRevenueByService => 'Revenue by service';

  @override
  String get chartExpensesByCategory => 'Expenses by category';

  @override
  String get noDataForPeriod => 'No data for this period';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleAccountant => 'Accountant';

  @override
  String get roleReception => 'Reception';

  @override
  String get roleViewer => 'Viewer';

  @override
  String get confirmDeleteTitle => 'Delete this record?';

  @override
  String get confirmDeleteMessage =>
      'This can be reversed by an Owner from the audit log, but it will be removed from all reports immediately.';

  @override
  String get noDataFound => 'No records found';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get requiredField => 'This field is required';

  @override
  String get comingSoonTitle => 'Coming in the next phase';

  @override
  String get comingSoonMessage =>
      'This screen\'s data layer is already built. The full interface arrives in the next part of the project.';

  @override
  String get revenueTitle => 'Revenue';

  @override
  String get addRevenue => 'Add revenue';

  @override
  String get editRevenue => 'Edit revenue';

  @override
  String get saveRevenue => 'Save revenue';

  @override
  String get patientCustomer => 'Patient / customer';

  @override
  String get walkInPatient => 'Walk-in (no patient on file)';

  @override
  String get doctor => 'Doctor';

  @override
  String get service => 'Service';

  @override
  String get grossAmount => 'Amount (EGP)';

  @override
  String get discount => 'Discount (EGP)';

  @override
  String get netRevenue => 'Net revenue';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get searchRevenueHint => 'Search by patient or transaction number';

  @override
  String get noRevenueYet => 'No revenue recorded yet';

  @override
  String get tapAddFirstTransaction =>
      'Tap the + button to record the first transaction.';

  @override
  String get possibleDuplicateTitle => 'Possible duplicate';

  @override
  String get possibleDuplicateMessage =>
      'A transaction with the same doctor, amount, and date already exists. Save this one anyway?';

  @override
  String get saveAnyway => 'Save anyway';

  @override
  String get deleteTransactionMessage =>
      'This can be reversed by an Owner from the audit log, but it will be removed from all reports and the cash balance will be adjusted immediately.';

  @override
  String get transactionSection => 'Transaction';

  @override
  String get amountsSection => 'Amounts';

  @override
  String get recordInfoSection => 'Record info';

  @override
  String get recorded => 'Recorded';

  @override
  String get lastModified => 'Last modified';

  @override
  String get doctorCommission => 'Doctor commission';

  @override
  String get centerShare => 'Center share';

  @override
  String get expensesTitle => 'Expenses';

  @override
  String get addExpense => 'Add expense';

  @override
  String get editExpense => 'Edit expense';

  @override
  String get saveExpense => 'Save expense';

  @override
  String get expenseCategory => 'Expense category';

  @override
  String get supplierOptional => 'Supplier (optional)';

  @override
  String get noSupplier => 'No supplier';

  @override
  String get description => 'Description';

  @override
  String get invoiceNumberOptional => 'Invoice number (optional)';

  @override
  String get searchExpenseHint => 'Search by description or expense number';

  @override
  String get noExpensesYet => 'No expenses recorded yet';

  @override
  String get tapAddFirstExpense =>
      'Tap the + button to record the first expense.';

  @override
  String get expenseCategoriesTitle => 'Expense categories';

  @override
  String get newCategory => 'New category';

  @override
  String get editCategory => 'Edit category';

  @override
  String get nameEnglish => 'Name (English)';

  @override
  String get nameArabicOptional => 'Name (Arabic, optional)';

  @override
  String get doctorsTitle => 'Doctors';

  @override
  String get addDoctor => 'Add doctor';

  @override
  String get editDoctor => 'Edit doctor';

  @override
  String get saveDoctor => 'Save doctor';

  @override
  String get doctorName => 'Doctor name';

  @override
  String get specialtyOptional => 'Specialty (optional)';

  @override
  String get commission => 'Commission';

  @override
  String get commissionStructure => 'Commission structure';

  @override
  String get commissionNone => 'None';

  @override
  String get commissionPercentage => 'Percentage';

  @override
  String get commissionFixed => 'Fixed fee';

  @override
  String get commissionPercentLabel => 'Commission (%)';

  @override
  String get commissionFixedLabel => 'Fixed fee per visit (EGP)';

  @override
  String get commissionFixedHelper =>
      'Applied per transaction. For a flat monthly retainer instead, record it as a recurring expense.';

  @override
  String get inactiveDoctorsHidden =>
      'Inactive doctors no longer appear when recording revenue';

  @override
  String get allTimePerformance => 'All-time performance';

  @override
  String get revenueGenerated => 'Revenue generated';

  @override
  String get commissionPaidToDoctor => 'Commission paid to doctor';

  @override
  String get servicesTitle => 'Services';

  @override
  String get addService => 'Add service';

  @override
  String get editService => 'Edit service';

  @override
  String get saveService => 'Save service';

  @override
  String get serviceName => 'Service name';

  @override
  String get categoryOptional => 'Category (optional)';

  @override
  String get priceLabel => 'Price (EGP)';

  @override
  String get defaultDoctorOptional => 'Default doctor (optional)';

  @override
  String get noDefaultDoctor => 'No default doctor';

  @override
  String get serviceDoctorHelper =>
      'Auto-fills when this service is selected on the revenue form, but stays editable per transaction.';

  @override
  String get inactiveServicesHidden =>
      'Inactive services are hidden from the revenue form';

  @override
  String get patientsTitle => 'Patients';

  @override
  String get addPatient => 'Add patient';

  @override
  String get editPatient => 'Edit patient';

  @override
  String get savePatient => 'Save patient';

  @override
  String get fullName => 'Full name';

  @override
  String get genderOptional => 'Gender (optional)';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get dateOfBirthOptional => 'Date of birth (optional)';

  @override
  String get notSet => 'Not set';

  @override
  String get searchPatientHint => 'Search by name or phone';

  @override
  String get noPatientsYet => 'No patients yet';

  @override
  String get transactionHistory => 'Transaction history';

  @override
  String get noTransactionsForPatient => 'No transactions for this patient yet';

  @override
  String get noAdditionalDetails => 'No additional details on file';

  @override
  String get suppliersTitle => 'Suppliers';

  @override
  String get addSupplier => 'Add supplier';

  @override
  String get editSupplier => 'Edit supplier';

  @override
  String get saveSupplier => 'Save supplier';

  @override
  String get supplierName => 'Supplier name';

  @override
  String get addressOptional => 'Address (optional)';

  @override
  String get taxIdOptional => 'Tax ID (optional)';

  @override
  String get noSuppliersYet => 'No suppliers yet';

  @override
  String get expenseHistory => 'Expense history';

  @override
  String get noExpensesForSupplier =>
      'No expenses recorded for this supplier yet';

  @override
  String get paymentAccountsTitle => 'Payment accounts';

  @override
  String get totalAcrossAccounts => 'Total across all accounts';

  @override
  String get byAccount => 'By account';

  @override
  String get openingBalance => 'Opening balance';

  @override
  String get accountsAutoUpdateNote =>
      'Balances update automatically as revenue and expenses are recorded - each transaction posts to the account tied to its payment method. There is nothing to reconcile here manually.';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportPnl => 'Profit & Loss';

  @override
  String get reportPnlSubtitle =>
      'Revenue, commissions, expenses, and net profit';

  @override
  String get reportCashFlow => 'Cash Flow';

  @override
  String get reportCashFlowSubtitle =>
      'Opening, inflows, outflows, and closing balance per account';

  @override
  String get reportDailyClosing => 'Daily Closing';

  @override
  String get reportDailyClosingSubtitle =>
      'Today\'s (or any day\'s) opening and closing cash';

  @override
  String get reportRevenue => 'Revenue Report';

  @override
  String get reportRevenueSubtitle =>
      'Every revenue transaction, with full detail';

  @override
  String get reportExpense => 'Expense Report';

  @override
  String get reportExpenseSubtitle =>
      'Every expense transaction, with full detail';

  @override
  String get reportDoctor => 'Doctor Report';

  @override
  String get reportDoctorSubtitle =>
      'Revenue, commission, and center share per doctor';

  @override
  String get reportService => 'Service Report';

  @override
  String get reportServiceSubtitle =>
      'Transaction count and revenue per service';

  @override
  String get reportCategory => 'Expense Category Report';

  @override
  String get reportCategorySubtitle =>
      'Transaction count and total per category';

  @override
  String get periodDaily => 'Daily';

  @override
  String get periodWeekly => 'Weekly';

  @override
  String get periodMonthly => 'Monthly';

  @override
  String get periodYearly => 'Yearly';

  @override
  String get grossRevenue => 'Gross revenue';

  @override
  String get discounts => 'Discounts';

  @override
  String get doctorCommissions => 'Doctor commissions';

  @override
  String get grossProfit => 'Gross profit';

  @override
  String get operatingExpenses => 'Operating expenses';

  @override
  String get netProfit => 'Net profit';

  @override
  String get cashInflows => 'Cash inflows';

  @override
  String get cashOutflows => 'Cash outflows';

  @override
  String get closingBalance => 'Closing balance';

  @override
  String get totalClosingBalance => 'Total closing balance';

  @override
  String get closingDate => 'Closing date';

  @override
  String get openingCash => 'Opening cash';

  @override
  String get cashRevenue => 'Cash revenue';

  @override
  String get cashExpenses => 'Cash expenses';

  @override
  String get closingCash => 'Closing cash';

  @override
  String get exportExcel => 'Excel';

  @override
  String get exportCsv => 'CSV';

  @override
  String get exportPdf => 'PDF';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get usersTitle => 'Users';

  @override
  String get usersSubtitle => 'Manage accounts and roles';

  @override
  String get paymentMethodsTitle => 'Payment methods';

  @override
  String get paymentMethodsSubtitle =>
      'Manage which methods post to which account';

  @override
  String get backupRestoreTitle => 'Backup & Restore';

  @override
  String get backupRestoreSubtitle =>
      'Save or restore a complete copy of your data';

  @override
  String get auditLogTitle => 'Audit log';

  @override
  String get auditLogSubtitle =>
      'Every create, edit, and delete, with who and when';

  @override
  String get aboutTitle => 'About';

  @override
  String get addUser => 'Add user';

  @override
  String get editUser => 'Edit user';

  @override
  String get username => 'Username';

  @override
  String get role => 'Role';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get cancelPasswordReset => 'Cancel password reset';

  @override
  String get newPassword => 'New password';

  @override
  String get cannotChangeOwnRole => 'You can\'t change your own role.';

  @override
  String get inactiveUsersCannotSignIn => 'Inactive users cannot sign in';

  @override
  String get newPaymentMethod => 'New payment method';

  @override
  String get methodName => 'Method name';

  @override
  String get postsToAccount => 'Posts to account';

  @override
  String get createBackupTitle => 'Create a backup';

  @override
  String get createBackupDescription =>
      'Saves a complete copy of every record in the app - revenue, expenses, doctors, services, patients, suppliers, and settings - to a single file you can save to Google Drive, email to yourself, or copy to a computer.';

  @override
  String get createBackupButton => 'Create backup';

  @override
  String get restoreBackupTitle => 'Restore from a backup';

  @override
  String get restoreBackupDescription =>
      'Replaces everything currently in the app with the contents of a backup file. Use this when setting up a new phone, or to undo serious data loss. You will see exactly what the backup contains before anything is replaced.';

  @override
  String get chooseBackupFile => 'Choose backup file';

  @override
  String get backupSecurityNote =>
      'Security note: a backup file can be opened by anyone who has it - it contains everything in your database. Store backup files somewhere you control, and avoid emailing them or leaving them in a shared folder.';

  @override
  String get restoreConfirmTitle => 'Restore this backup?';

  @override
  String get restoreConfirmWarning =>
      'This will completely replace everything currently in the app - all revenue, expenses, doctors, services, patients, suppliers, and users. This cannot be undone unless you have another backup of the current data.';

  @override
  String get restoreConfirmButton => 'Replace everything and restore';

  @override
  String get recordTypeAll => 'All records';

  @override
  String get actionAll => 'All actions';

  @override
  String get actionCreated => 'Created';

  @override
  String get actionUpdated => 'Updated';

  @override
  String get actionDeleted => 'Deleted';

  @override
  String get noMatchingAuditEntries => 'No matching audit entries';
}
