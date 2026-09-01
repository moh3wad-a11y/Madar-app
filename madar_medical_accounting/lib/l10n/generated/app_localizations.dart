import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Madar Medical Center Accounting'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get navRevenue;

  /// No description provided for @navExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get navExpenses;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @navDoctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get navDoctors;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navPatients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get navPatients;

  /// No description provided for @navSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get navSuppliers;

  /// No description provided for @navPaymentAccounts.
  ///
  /// In en, this message translates to:
  /// **'Payment accounts'**
  String get navPaymentAccounts;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcome;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password'**
  String get invalidCredentials;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @defaultLoginHint.
  ///
  /// In en, this message translates to:
  /// **'Default owner login: admin / admin123 - change this immediately after first sign-in.'**
  String get defaultLoginHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptional;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @filterAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get filterAllTime;

  /// No description provided for @filterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get filterToday;

  /// No description provided for @filterYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get filterYesterday;

  /// No description provided for @filterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get filterThisWeek;

  /// No description provided for @filterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get filterThisMonth;

  /// No description provided for @filterLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get filterLastMonth;

  /// No description provided for @filterThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get filterThisYear;

  /// No description provided for @filterCustomRange.
  ///
  /// In en, this message translates to:
  /// **'Custom range'**
  String get filterCustomRange;

  /// No description provided for @filterCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get filterCustom;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toDate;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @todayRevenue.
  ///
  /// In en, this message translates to:
  /// **'Today\'s revenue'**
  String get todayRevenue;

  /// No description provided for @todayExpenses.
  ///
  /// In en, this message translates to:
  /// **'Today\'s expenses'**
  String get todayExpenses;

  /// No description provided for @todayNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Today\'s net profit'**
  String get todayNetProfit;

  /// No description provided for @cashBalance.
  ///
  /// In en, this message translates to:
  /// **'Cash balance'**
  String get cashBalance;

  /// No description provided for @selectedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Selected period'**
  String get selectedPeriod;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get monthlyRevenue;

  /// No description provided for @monthlyExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get monthlyExpenses;

  /// No description provided for @monthlyNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net profit'**
  String get monthlyNetProfit;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionCount;

  /// No description provided for @chartRevenueVsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Revenue vs expenses'**
  String get chartRevenueVsExpenses;

  /// No description provided for @chartRevenueByDoctor.
  ///
  /// In en, this message translates to:
  /// **'Revenue by doctor'**
  String get chartRevenueByDoctor;

  /// No description provided for @chartRevenueByService.
  ///
  /// In en, this message translates to:
  /// **'Revenue by service'**
  String get chartRevenueByService;

  /// No description provided for @chartExpensesByCategory.
  ///
  /// In en, this message translates to:
  /// **'Expenses by category'**
  String get chartExpensesByCategory;

  /// No description provided for @noDataForPeriod.
  ///
  /// In en, this message translates to:
  /// **'No data for this period'**
  String get noDataForPeriod;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeUser(String name);

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleAccountant.
  ///
  /// In en, this message translates to:
  /// **'Accountant'**
  String get roleAccountant;

  /// No description provided for @roleReception.
  ///
  /// In en, this message translates to:
  /// **'Reception'**
  String get roleReception;

  /// No description provided for @roleViewer.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get roleViewer;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This can be reversed by an Owner from the audit log, but it will be removed from all reports immediately.'**
  String get confirmDeleteMessage;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get noDataFound;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming in the next phase'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'This screen\'s data layer is already built. The full interface arrives in the next part of the project.'**
  String get comingSoonMessage;

  /// No description provided for @revenueTitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenueTitle;

  /// No description provided for @addRevenue.
  ///
  /// In en, this message translates to:
  /// **'Add revenue'**
  String get addRevenue;

  /// No description provided for @editRevenue.
  ///
  /// In en, this message translates to:
  /// **'Edit revenue'**
  String get editRevenue;

  /// No description provided for @saveRevenue.
  ///
  /// In en, this message translates to:
  /// **'Save revenue'**
  String get saveRevenue;

  /// No description provided for @patientCustomer.
  ///
  /// In en, this message translates to:
  /// **'Patient / customer'**
  String get patientCustomer;

  /// No description provided for @walkInPatient.
  ///
  /// In en, this message translates to:
  /// **'Walk-in (no patient on file)'**
  String get walkInPatient;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @grossAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount (EGP)'**
  String get grossAmount;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount (EGP)'**
  String get discount;

  /// No description provided for @netRevenue.
  ///
  /// In en, this message translates to:
  /// **'Net revenue'**
  String get netRevenue;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @searchRevenueHint.
  ///
  /// In en, this message translates to:
  /// **'Search by patient or transaction number'**
  String get searchRevenueHint;

  /// No description provided for @noRevenueYet.
  ///
  /// In en, this message translates to:
  /// **'No revenue recorded yet'**
  String get noRevenueYet;

  /// No description provided for @tapAddFirstTransaction.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to record the first transaction.'**
  String get tapAddFirstTransaction;

  /// No description provided for @possibleDuplicateTitle.
  ///
  /// In en, this message translates to:
  /// **'Possible duplicate'**
  String get possibleDuplicateTitle;

  /// No description provided for @possibleDuplicateMessage.
  ///
  /// In en, this message translates to:
  /// **'A transaction with the same doctor, amount, and date already exists. Save this one anyway?'**
  String get possibleDuplicateMessage;

  /// No description provided for @saveAnyway.
  ///
  /// In en, this message translates to:
  /// **'Save anyway'**
  String get saveAnyway;

  /// No description provided for @deleteTransactionMessage.
  ///
  /// In en, this message translates to:
  /// **'This can be reversed by an Owner from the audit log, but it will be removed from all reports and the cash balance will be adjusted immediately.'**
  String get deleteTransactionMessage;

  /// No description provided for @transactionSection.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transactionSection;

  /// No description provided for @amountsSection.
  ///
  /// In en, this message translates to:
  /// **'Amounts'**
  String get amountsSection;

  /// No description provided for @recordInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Record info'**
  String get recordInfoSection;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get recorded;

  /// No description provided for @lastModified.
  ///
  /// In en, this message translates to:
  /// **'Last modified'**
  String get lastModified;

  /// No description provided for @doctorCommission.
  ///
  /// In en, this message translates to:
  /// **'Doctor commission'**
  String get doctorCommission;

  /// No description provided for @centerShare.
  ///
  /// In en, this message translates to:
  /// **'Center share'**
  String get centerShare;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get editExpense;

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'Save expense'**
  String get saveExpense;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Expense category'**
  String get expenseCategory;

  /// No description provided for @supplierOptional.
  ///
  /// In en, this message translates to:
  /// **'Supplier (optional)'**
  String get supplierOptional;

  /// No description provided for @noSupplier.
  ///
  /// In en, this message translates to:
  /// **'No supplier'**
  String get noSupplier;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @invoiceNumberOptional.
  ///
  /// In en, this message translates to:
  /// **'Invoice number (optional)'**
  String get invoiceNumberOptional;

  /// No description provided for @searchExpenseHint.
  ///
  /// In en, this message translates to:
  /// **'Search by description or expense number'**
  String get searchExpenseHint;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded yet'**
  String get noExpensesYet;

  /// No description provided for @tapAddFirstExpense.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to record the first expense.'**
  String get tapAddFirstExpense;

  /// No description provided for @expenseCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense categories'**
  String get expenseCategoriesTitle;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @nameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Name (English)'**
  String get nameEnglish;

  /// No description provided for @nameArabicOptional.
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic, optional)'**
  String get nameArabicOptional;

  /// No description provided for @doctorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctorsTitle;

  /// No description provided for @addDoctor.
  ///
  /// In en, this message translates to:
  /// **'Add doctor'**
  String get addDoctor;

  /// No description provided for @editDoctor.
  ///
  /// In en, this message translates to:
  /// **'Edit doctor'**
  String get editDoctor;

  /// No description provided for @saveDoctor.
  ///
  /// In en, this message translates to:
  /// **'Save doctor'**
  String get saveDoctor;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor name'**
  String get doctorName;

  /// No description provided for @specialtyOptional.
  ///
  /// In en, this message translates to:
  /// **'Specialty (optional)'**
  String get specialtyOptional;

  /// No description provided for @commission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commission;

  /// No description provided for @commissionStructure.
  ///
  /// In en, this message translates to:
  /// **'Commission structure'**
  String get commissionStructure;

  /// No description provided for @commissionNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commissionNone;

  /// No description provided for @commissionPercentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get commissionPercentage;

  /// No description provided for @commissionFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed fee'**
  String get commissionFixed;

  /// No description provided for @commissionPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Commission (%)'**
  String get commissionPercentLabel;

  /// No description provided for @commissionFixedLabel.
  ///
  /// In en, this message translates to:
  /// **'Fixed fee per visit (EGP)'**
  String get commissionFixedLabel;

  /// No description provided for @commissionFixedHelper.
  ///
  /// In en, this message translates to:
  /// **'Applied per transaction. For a flat monthly retainer instead, record it as a recurring expense.'**
  String get commissionFixedHelper;

  /// No description provided for @inactiveDoctorsHidden.
  ///
  /// In en, this message translates to:
  /// **'Inactive doctors no longer appear when recording revenue'**
  String get inactiveDoctorsHidden;

  /// No description provided for @allTimePerformance.
  ///
  /// In en, this message translates to:
  /// **'All-time performance'**
  String get allTimePerformance;

  /// No description provided for @revenueGenerated.
  ///
  /// In en, this message translates to:
  /// **'Revenue generated'**
  String get revenueGenerated;

  /// No description provided for @commissionPaidToDoctor.
  ///
  /// In en, this message translates to:
  /// **'Commission paid to doctor'**
  String get commissionPaidToDoctor;

  /// No description provided for @servicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTitle;

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add service'**
  String get addService;

  /// No description provided for @editService.
  ///
  /// In en, this message translates to:
  /// **'Edit service'**
  String get editService;

  /// No description provided for @saveService.
  ///
  /// In en, this message translates to:
  /// **'Save service'**
  String get saveService;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get serviceName;

  /// No description provided for @categoryOptional.
  ///
  /// In en, this message translates to:
  /// **'Category (optional)'**
  String get categoryOptional;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (EGP)'**
  String get priceLabel;

  /// No description provided for @defaultDoctorOptional.
  ///
  /// In en, this message translates to:
  /// **'Default doctor (optional)'**
  String get defaultDoctorOptional;

  /// No description provided for @noDefaultDoctor.
  ///
  /// In en, this message translates to:
  /// **'No default doctor'**
  String get noDefaultDoctor;

  /// No description provided for @serviceDoctorHelper.
  ///
  /// In en, this message translates to:
  /// **'Auto-fills when this service is selected on the revenue form, but stays editable per transaction.'**
  String get serviceDoctorHelper;

  /// No description provided for @inactiveServicesHidden.
  ///
  /// In en, this message translates to:
  /// **'Inactive services are hidden from the revenue form'**
  String get inactiveServicesHidden;

  /// No description provided for @patientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patientsTitle;

  /// No description provided for @addPatient.
  ///
  /// In en, this message translates to:
  /// **'Add patient'**
  String get addPatient;

  /// No description provided for @editPatient.
  ///
  /// In en, this message translates to:
  /// **'Edit patient'**
  String get editPatient;

  /// No description provided for @savePatient.
  ///
  /// In en, this message translates to:
  /// **'Save patient'**
  String get savePatient;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @genderOptional.
  ///
  /// In en, this message translates to:
  /// **'Gender (optional)'**
  String get genderOptional;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @dateOfBirthOptional.
  ///
  /// In en, this message translates to:
  /// **'Date of birth (optional)'**
  String get dateOfBirthOptional;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @searchPatientHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone'**
  String get searchPatientHint;

  /// No description provided for @noPatientsYet.
  ///
  /// In en, this message translates to:
  /// **'No patients yet'**
  String get noPatientsYet;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get transactionHistory;

  /// No description provided for @noTransactionsForPatient.
  ///
  /// In en, this message translates to:
  /// **'No transactions for this patient yet'**
  String get noTransactionsForPatient;

  /// No description provided for @noAdditionalDetails.
  ///
  /// In en, this message translates to:
  /// **'No additional details on file'**
  String get noAdditionalDetails;

  /// No description provided for @suppliersTitle.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliersTitle;

  /// No description provided for @addSupplier.
  ///
  /// In en, this message translates to:
  /// **'Add supplier'**
  String get addSupplier;

  /// No description provided for @editSupplier.
  ///
  /// In en, this message translates to:
  /// **'Edit supplier'**
  String get editSupplier;

  /// No description provided for @saveSupplier.
  ///
  /// In en, this message translates to:
  /// **'Save supplier'**
  String get saveSupplier;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier name'**
  String get supplierName;

  /// No description provided for @addressOptional.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get addressOptional;

  /// No description provided for @taxIdOptional.
  ///
  /// In en, this message translates to:
  /// **'Tax ID (optional)'**
  String get taxIdOptional;

  /// No description provided for @noSuppliersYet.
  ///
  /// In en, this message translates to:
  /// **'No suppliers yet'**
  String get noSuppliersYet;

  /// No description provided for @expenseHistory.
  ///
  /// In en, this message translates to:
  /// **'Expense history'**
  String get expenseHistory;

  /// No description provided for @noExpensesForSupplier.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded for this supplier yet'**
  String get noExpensesForSupplier;

  /// No description provided for @paymentAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment accounts'**
  String get paymentAccountsTitle;

  /// No description provided for @totalAcrossAccounts.
  ///
  /// In en, this message translates to:
  /// **'Total across all accounts'**
  String get totalAcrossAccounts;

  /// No description provided for @byAccount.
  ///
  /// In en, this message translates to:
  /// **'By account'**
  String get byAccount;

  /// No description provided for @openingBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get openingBalance;

  /// No description provided for @accountsAutoUpdateNote.
  ///
  /// In en, this message translates to:
  /// **'Balances update automatically as revenue and expenses are recorded - each transaction posts to the account tied to its payment method. There is nothing to reconcile here manually.'**
  String get accountsAutoUpdateNote;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportPnl.
  ///
  /// In en, this message translates to:
  /// **'Profit & Loss'**
  String get reportPnl;

  /// No description provided for @reportPnlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue, commissions, expenses, and net profit'**
  String get reportPnlSubtitle;

  /// No description provided for @reportCashFlow.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow'**
  String get reportCashFlow;

  /// No description provided for @reportCashFlowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Opening, inflows, outflows, and closing balance per account'**
  String get reportCashFlowSubtitle;

  /// No description provided for @reportDailyClosing.
  ///
  /// In en, this message translates to:
  /// **'Daily Closing'**
  String get reportDailyClosing;

  /// No description provided for @reportDailyClosingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s (or any day\'s) opening and closing cash'**
  String get reportDailyClosingSubtitle;

  /// No description provided for @reportRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue Report'**
  String get reportRevenue;

  /// No description provided for @reportRevenueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every revenue transaction, with full detail'**
  String get reportRevenueSubtitle;

  /// No description provided for @reportExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense Report'**
  String get reportExpense;

  /// No description provided for @reportExpenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every expense transaction, with full detail'**
  String get reportExpenseSubtitle;

  /// No description provided for @reportDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor Report'**
  String get reportDoctor;

  /// No description provided for @reportDoctorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue, commission, and center share per doctor'**
  String get reportDoctorSubtitle;

  /// No description provided for @reportService.
  ///
  /// In en, this message translates to:
  /// **'Service Report'**
  String get reportService;

  /// No description provided for @reportServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction count and revenue per service'**
  String get reportServiceSubtitle;

  /// No description provided for @reportCategory.
  ///
  /// In en, this message translates to:
  /// **'Expense Category Report'**
  String get reportCategory;

  /// No description provided for @reportCategorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction count and total per category'**
  String get reportCategorySubtitle;

  /// No description provided for @periodDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get periodDaily;

  /// No description provided for @periodWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get periodWeekly;

  /// No description provided for @periodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get periodMonthly;

  /// No description provided for @periodYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get periodYearly;

  /// No description provided for @grossRevenue.
  ///
  /// In en, this message translates to:
  /// **'Gross revenue'**
  String get grossRevenue;

  /// No description provided for @discounts.
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get discounts;

  /// No description provided for @doctorCommissions.
  ///
  /// In en, this message translates to:
  /// **'Doctor commissions'**
  String get doctorCommissions;

  /// No description provided for @grossProfit.
  ///
  /// In en, this message translates to:
  /// **'Gross profit'**
  String get grossProfit;

  /// No description provided for @operatingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Operating expenses'**
  String get operatingExpenses;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net profit'**
  String get netProfit;

  /// No description provided for @cashInflows.
  ///
  /// In en, this message translates to:
  /// **'Cash inflows'**
  String get cashInflows;

  /// No description provided for @cashOutflows.
  ///
  /// In en, this message translates to:
  /// **'Cash outflows'**
  String get cashOutflows;

  /// No description provided for @closingBalance.
  ///
  /// In en, this message translates to:
  /// **'Closing balance'**
  String get closingBalance;

  /// No description provided for @totalClosingBalance.
  ///
  /// In en, this message translates to:
  /// **'Total closing balance'**
  String get totalClosingBalance;

  /// No description provided for @closingDate.
  ///
  /// In en, this message translates to:
  /// **'Closing date'**
  String get closingDate;

  /// No description provided for @openingCash.
  ///
  /// In en, this message translates to:
  /// **'Opening cash'**
  String get openingCash;

  /// No description provided for @cashRevenue.
  ///
  /// In en, this message translates to:
  /// **'Cash revenue'**
  String get cashRevenue;

  /// No description provided for @cashExpenses.
  ///
  /// In en, this message translates to:
  /// **'Cash expenses'**
  String get cashExpenses;

  /// No description provided for @closingCash.
  ///
  /// In en, this message translates to:
  /// **'Closing cash'**
  String get closingCash;

  /// No description provided for @exportExcel.
  ///
  /// In en, this message translates to:
  /// **'Excel'**
  String get exportExcel;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get exportCsv;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get exportPdf;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @usersTitle.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersTitle;

  /// No description provided for @usersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage accounts and roles'**
  String get usersSubtitle;

  /// No description provided for @paymentMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get paymentMethodsTitle;

  /// No description provided for @paymentMethodsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage which methods post to which account'**
  String get paymentMethodsSubtitle;

  /// No description provided for @backupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestoreTitle;

  /// No description provided for @backupRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save or restore a complete copy of your data'**
  String get backupRestoreSubtitle;

  /// No description provided for @auditLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get auditLogTitle;

  /// No description provided for @auditLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every create, edit, and delete, with who and when'**
  String get auditLogSubtitle;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get addUser;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get editUser;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @cancelPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Cancel password reset'**
  String get cancelPasswordReset;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @cannotChangeOwnRole.
  ///
  /// In en, this message translates to:
  /// **'You can\'t change your own role.'**
  String get cannotChangeOwnRole;

  /// No description provided for @inactiveUsersCannotSignIn.
  ///
  /// In en, this message translates to:
  /// **'Inactive users cannot sign in'**
  String get inactiveUsersCannotSignIn;

  /// No description provided for @newPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'New payment method'**
  String get newPaymentMethod;

  /// No description provided for @methodName.
  ///
  /// In en, this message translates to:
  /// **'Method name'**
  String get methodName;

  /// No description provided for @postsToAccount.
  ///
  /// In en, this message translates to:
  /// **'Posts to account'**
  String get postsToAccount;

  /// No description provided for @createBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a backup'**
  String get createBackupTitle;

  /// No description provided for @createBackupDescription.
  ///
  /// In en, this message translates to:
  /// **'Saves a complete copy of every record in the app - revenue, expenses, doctors, services, patients, suppliers, and settings - to a single file you can save to Google Drive, email to yourself, or copy to a computer.'**
  String get createBackupDescription;

  /// No description provided for @createBackupButton.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get createBackupButton;

  /// No description provided for @restoreBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from a backup'**
  String get restoreBackupTitle;

  /// No description provided for @restoreBackupDescription.
  ///
  /// In en, this message translates to:
  /// **'Replaces everything currently in the app with the contents of a backup file. Use this when setting up a new phone, or to undo serious data loss. You will see exactly what the backup contains before anything is replaced.'**
  String get restoreBackupDescription;

  /// No description provided for @chooseBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Choose backup file'**
  String get chooseBackupFile;

  /// No description provided for @backupSecurityNote.
  ///
  /// In en, this message translates to:
  /// **'Security note: a backup file can be opened by anyone who has it - it contains everything in your database. Store backup files somewhere you control, and avoid emailing them or leaving them in a shared folder.'**
  String get backupSecurityNote;

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get restoreConfirmTitle;

  /// No description provided for @restoreConfirmWarning.
  ///
  /// In en, this message translates to:
  /// **'This will completely replace everything currently in the app - all revenue, expenses, doctors, services, patients, suppliers, and users. This cannot be undone unless you have another backup of the current data.'**
  String get restoreConfirmWarning;

  /// No description provided for @restoreConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Replace everything and restore'**
  String get restoreConfirmButton;

  /// No description provided for @recordTypeAll.
  ///
  /// In en, this message translates to:
  /// **'All records'**
  String get recordTypeAll;

  /// No description provided for @actionAll.
  ///
  /// In en, this message translates to:
  /// **'All actions'**
  String get actionAll;

  /// No description provided for @actionCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get actionCreated;

  /// No description provided for @actionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get actionUpdated;

  /// No description provided for @actionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get actionDeleted;

  /// No description provided for @noMatchingAuditEntries.
  ///
  /// In en, this message translates to:
  /// **'No matching audit entries'**
  String get noMatchingAuditEntries;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
