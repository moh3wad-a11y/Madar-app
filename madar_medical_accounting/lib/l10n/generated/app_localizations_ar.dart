// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مدار - حسابات المركز الطبي';

  @override
  String get navDashboard => 'لوحة التحكم';

  @override
  String get navRevenue => 'الإيرادات';

  @override
  String get navExpenses => 'المصروفات';

  @override
  String get navReports => 'التقارير';

  @override
  String get navMore => 'المزيد';

  @override
  String get navDoctors => 'الأطباء';

  @override
  String get navServices => 'الخدمات';

  @override
  String get navPatients => 'المرضى';

  @override
  String get navSuppliers => 'الموردون';

  @override
  String get navPaymentAccounts => 'حسابات الدفع';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginWelcome => 'أهلاً بعودتك';

  @override
  String get usernameLabel => 'اسم المستخدم';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get invalidCredentials => 'اسم المستخدم أو كلمة المرور غير صحيحة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get defaultLoginHint =>
      'بيانات دخول المالك الافتراضية: admin / admin123 - يرجى تغييرها فور تسجيل الدخول الأول.';

  @override
  String get save => 'حفظ';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get search => 'بحث';

  @override
  String get confirm => 'تأكيد';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get notes => 'ملاحظات';

  @override
  String get notesOptional => 'ملاحظات (اختياري)';

  @override
  String get active => 'نشط';

  @override
  String get inactive => 'غير نشط';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get phoneOptional => 'الهاتف (اختياري)';

  @override
  String get amount => 'المبلغ';

  @override
  String get total => 'الإجمالي';

  @override
  String get close => 'إغلاق';

  @override
  String get filterAllTime => 'كل الفترات';

  @override
  String get filterToday => 'اليوم';

  @override
  String get filterYesterday => 'أمس';

  @override
  String get filterThisWeek => 'هذا الأسبوع';

  @override
  String get filterThisMonth => 'هذا الشهر';

  @override
  String get filterLastMonth => 'الشهر الماضي';

  @override
  String get filterThisYear => 'هذا العام';

  @override
  String get filterCustomRange => 'فترة مخصصة';

  @override
  String get filterCustom => 'مخصص';

  @override
  String get fromDate => 'من';

  @override
  String get toDate => 'إلى';

  @override
  String get todayLabel => 'اليوم';

  @override
  String get todayRevenue => 'إيرادات اليوم';

  @override
  String get todayExpenses => 'مصروفات اليوم';

  @override
  String get todayNetProfit => 'صافي ربح اليوم';

  @override
  String get cashBalance => 'الرصيد النقدي';

  @override
  String get selectedPeriod => 'الفترة المحددة';

  @override
  String get monthlyRevenue => 'الإيرادات';

  @override
  String get monthlyExpenses => 'المصروفات';

  @override
  String get monthlyNetProfit => 'صافي الربح';

  @override
  String get transactionCount => 'عدد المعاملات';

  @override
  String get chartRevenueVsExpenses => 'الإيرادات مقابل المصروفات';

  @override
  String get chartRevenueByDoctor => 'الإيرادات حسب الطبيب';

  @override
  String get chartRevenueByService => 'الإيرادات حسب الخدمة';

  @override
  String get chartExpensesByCategory => 'المصروفات حسب الفئة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String welcomeUser(String name) {
    return 'أهلاً بك، $name';
  }

  @override
  String get roleOwner => 'مالك';

  @override
  String get roleAccountant => 'محاسب';

  @override
  String get roleReception => 'استقبال';

  @override
  String get roleViewer => 'مشاهد';

  @override
  String get confirmDeleteTitle => 'هل تريد حذف هذا السجل؟';

  @override
  String get confirmDeleteMessage =>
      'يمكن لمالك النظام التراجع عن هذا الإجراء من سجل التدقيق، لكنه سيُستبعد من التقارير فوراً.';

  @override
  String get noDataFound => 'لا توجد سجلات';

  @override
  String get errorGeneric => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get comingSoonTitle => 'قادم في المرحلة التالية';

  @override
  String get comingSoonMessage =>
      'طبقة البيانات لهذه الشاشة جاهزة بالفعل. الواجهة الكاملة ستصل في الجزء التالي من المشروع.';

  @override
  String get revenueTitle => 'الإيرادات';

  @override
  String get addRevenue => 'إضافة إيراد';

  @override
  String get editRevenue => 'تعديل الإيراد';

  @override
  String get saveRevenue => 'حفظ الإيراد';

  @override
  String get patientCustomer => 'المريض / العميل';

  @override
  String get walkInPatient => 'زيارة بدون تسجيل مريض';

  @override
  String get doctor => 'الطبيب';

  @override
  String get service => 'الخدمة';

  @override
  String get grossAmount => 'المبلغ (جنيه)';

  @override
  String get discount => 'الخصم (جنيه)';

  @override
  String get netRevenue => 'صافي الإيراد';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get searchRevenueHint => 'ابحث باسم المريض أو رقم المعاملة';

  @override
  String get noRevenueYet => 'لا توجد إيرادات مسجلة بعد';

  @override
  String get tapAddFirstTransaction => 'اضغط على زر + لتسجيل أول معاملة.';

  @override
  String get possibleDuplicateTitle => 'احتمال تكرار';

  @override
  String get possibleDuplicateMessage =>
      'توجد بالفعل معاملة بنفس الطبيب والمبلغ والتاريخ. هل تريد الحفظ رغم ذلك؟';

  @override
  String get saveAnyway => 'احفظ رغم ذلك';

  @override
  String get deleteTransactionMessage =>
      'يمكن لمالك النظام التراجع عن هذا من سجل التدقيق، لكنه سيُستبعد من التقارير فوراً وسيتم تعديل الرصيد النقدي فوراً.';

  @override
  String get transactionSection => 'المعاملة';

  @override
  String get amountsSection => 'المبالغ';

  @override
  String get recordInfoSection => 'معلومات السجل';

  @override
  String get recorded => 'تاريخ التسجيل';

  @override
  String get lastModified => 'آخر تعديل';

  @override
  String get doctorCommission => 'عمولة الطبيب';

  @override
  String get centerShare => 'نصيب المركز';

  @override
  String get expensesTitle => 'المصروفات';

  @override
  String get addExpense => 'إضافة مصروف';

  @override
  String get editExpense => 'تعديل المصروف';

  @override
  String get saveExpense => 'حفظ المصروف';

  @override
  String get expenseCategory => 'فئة المصروف';

  @override
  String get supplierOptional => 'المورد (اختياري)';

  @override
  String get noSupplier => 'بدون مورد';

  @override
  String get description => 'الوصف';

  @override
  String get invoiceNumberOptional => 'رقم الفاتورة (اختياري)';

  @override
  String get searchExpenseHint => 'ابحث بالوصف أو رقم المصروف';

  @override
  String get noExpensesYet => 'لا توجد مصروفات مسجلة بعد';

  @override
  String get tapAddFirstExpense => 'اضغط على زر + لتسجيل أول مصروف.';

  @override
  String get expenseCategoriesTitle => 'فئات المصروفات';

  @override
  String get newCategory => 'فئة جديدة';

  @override
  String get editCategory => 'تعديل الفئة';

  @override
  String get nameEnglish => 'الاسم (إنجليزي)';

  @override
  String get nameArabicOptional => 'الاسم (عربي، اختياري)';

  @override
  String get doctorsTitle => 'الأطباء';

  @override
  String get addDoctor => 'إضافة طبيب';

  @override
  String get editDoctor => 'تعديل بيانات الطبيب';

  @override
  String get saveDoctor => 'حفظ الطبيب';

  @override
  String get doctorName => 'اسم الطبيب';

  @override
  String get specialtyOptional => 'التخصص (اختياري)';

  @override
  String get commission => 'العمولة';

  @override
  String get commissionStructure => 'نظام العمولة';

  @override
  String get commissionNone => 'بدون عمولة';

  @override
  String get commissionPercentage => 'نسبة مئوية';

  @override
  String get commissionFixed => 'مبلغ ثابت';

  @override
  String get commissionPercentLabel => 'نسبة العمولة (%)';

  @override
  String get commissionFixedLabel => 'مبلغ ثابت لكل زيارة (جنيه)';

  @override
  String get commissionFixedHelper =>
      'يُطبّق على كل معاملة على حدة. للحصول على مكافأة شهرية ثابتة بدلاً من ذلك، سجّلها كمصروف متكرر.';

  @override
  String get inactiveDoctorsHidden =>
      'الأطباء غير النشطين لا يظهرون عند تسجيل الإيرادات';

  @override
  String get allTimePerformance => 'الأداء منذ البداية';

  @override
  String get revenueGenerated => 'الإيرادات المحققة';

  @override
  String get commissionPaidToDoctor => 'العمولة المدفوعة للطبيب';

  @override
  String get servicesTitle => 'الخدمات';

  @override
  String get addService => 'إضافة خدمة';

  @override
  String get editService => 'تعديل الخدمة';

  @override
  String get saveService => 'حفظ الخدمة';

  @override
  String get serviceName => 'اسم الخدمة';

  @override
  String get categoryOptional => 'الفئة (اختياري)';

  @override
  String get priceLabel => 'السعر (جنيه)';

  @override
  String get defaultDoctorOptional => 'الطبيب الافتراضي (اختياري)';

  @override
  String get noDefaultDoctor => 'بدون طبيب افتراضي';

  @override
  String get serviceDoctorHelper =>
      'يتم تعبئته تلقائياً عند اختيار هذه الخدمة في نموذج الإيراد، ويبقى قابلاً للتعديل لكل معاملة.';

  @override
  String get inactiveServicesHidden =>
      'الخدمات غير النشطة مخفية من نموذج الإيراد';

  @override
  String get patientsTitle => 'المرضى';

  @override
  String get addPatient => 'إضافة مريض';

  @override
  String get editPatient => 'تعديل بيانات المريض';

  @override
  String get savePatient => 'حفظ المريض';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get genderOptional => 'النوع (اختياري)';

  @override
  String get genderMale => 'ذكر';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get dateOfBirthOptional => 'تاريخ الميلاد (اختياري)';

  @override
  String get notSet => 'غير محدد';

  @override
  String get searchPatientHint => 'ابحث بالاسم أو رقم الهاتف';

  @override
  String get noPatientsYet => 'لا يوجد مرضى بعد';

  @override
  String get transactionHistory => 'سجل المعاملات';

  @override
  String get noTransactionsForPatient => 'لا توجد معاملات لهذا المريض بعد';

  @override
  String get noAdditionalDetails => 'لا توجد تفاصيل إضافية مسجلة';

  @override
  String get suppliersTitle => 'الموردون';

  @override
  String get addSupplier => 'إضافة مورد';

  @override
  String get editSupplier => 'تعديل بيانات المورد';

  @override
  String get saveSupplier => 'حفظ المورد';

  @override
  String get supplierName => 'اسم المورد';

  @override
  String get addressOptional => 'العنوان (اختياري)';

  @override
  String get taxIdOptional => 'الرقم الضريبي (اختياري)';

  @override
  String get noSuppliersYet => 'لا يوجد موردون بعد';

  @override
  String get expenseHistory => 'سجل المصروفات';

  @override
  String get noExpensesForSupplier => 'لا توجد مصروفات مسجلة لهذا المورد بعد';

  @override
  String get paymentAccountsTitle => 'حسابات الدفع';

  @override
  String get totalAcrossAccounts => 'الإجمالي في جميع الحسابات';

  @override
  String get byAccount => 'حسب الحساب';

  @override
  String get openingBalance => 'الرصيد الافتتاحي';

  @override
  String get accountsAutoUpdateNote =>
      'تُحدَّث الأرصدة تلقائياً عند تسجيل الإيرادات والمصروفات - كل معاملة تُرحَّل إلى الحساب المرتبط بطريقة الدفع الخاصة بها. لا حاجة لأي تسوية يدوية هنا.';

  @override
  String get reportsTitle => 'التقارير';

  @override
  String get reportPnl => 'الأرباح والخسائر';

  @override
  String get reportPnlSubtitle => 'الإيرادات والعمولات والمصروفات وصافي الربح';

  @override
  String get reportCashFlow => 'التدفق النقدي';

  @override
  String get reportCashFlowSubtitle =>
      'الرصيد الافتتاحي والتدفقات الداخلة والخارجة والرصيد الختامي لكل حساب';

  @override
  String get reportDailyClosing => 'الإقفال اليومي';

  @override
  String get reportDailyClosingSubtitle =>
      'الرصيد النقدي الافتتاحي والختامي لليوم (أو أي يوم آخر)';

  @override
  String get reportRevenue => 'تقرير الإيرادات';

  @override
  String get reportRevenueSubtitle => 'كل معاملة إيراد بكامل تفاصيلها';

  @override
  String get reportExpense => 'تقرير المصروفات';

  @override
  String get reportExpenseSubtitle => 'كل معاملة مصروف بكامل تفاصيلها';

  @override
  String get reportDoctor => 'تقرير الأطباء';

  @override
  String get reportDoctorSubtitle => 'الإيرادات والعمولة ونصيب المركز لكل طبيب';

  @override
  String get reportService => 'تقرير الخدمات';

  @override
  String get reportServiceSubtitle => 'عدد المعاملات والإيرادات لكل خدمة';

  @override
  String get reportCategory => 'تقرير فئات المصروفات';

  @override
  String get reportCategorySubtitle => 'عدد المعاملات والإجمالي لكل فئة';

  @override
  String get periodDaily => 'يومي';

  @override
  String get periodWeekly => 'أسبوعي';

  @override
  String get periodMonthly => 'شهري';

  @override
  String get periodYearly => 'سنوي';

  @override
  String get grossRevenue => 'إجمالي الإيرادات';

  @override
  String get discounts => 'الخصومات';

  @override
  String get doctorCommissions => 'عمولات الأطباء';

  @override
  String get grossProfit => 'إجمالي الربح';

  @override
  String get operatingExpenses => 'المصروفات التشغيلية';

  @override
  String get netProfit => 'صافي الربح';

  @override
  String get cashInflows => 'التدفقات النقدية الداخلة';

  @override
  String get cashOutflows => 'التدفقات النقدية الخارجة';

  @override
  String get closingBalance => 'الرصيد الختامي';

  @override
  String get totalClosingBalance => 'إجمالي الرصيد الختامي';

  @override
  String get closingDate => 'تاريخ الإقفال';

  @override
  String get openingCash => 'النقدية الافتتاحية';

  @override
  String get cashRevenue => 'الإيرادات النقدية';

  @override
  String get cashExpenses => 'المصروفات النقدية';

  @override
  String get closingCash => 'النقدية الختامية';

  @override
  String get exportExcel => 'إكسل';

  @override
  String get exportCsv => 'CSV';

  @override
  String get exportPdf => 'PDF';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get usersTitle => 'المستخدمون';

  @override
  String get usersSubtitle => 'إدارة الحسابات والصلاحيات';

  @override
  String get paymentMethodsTitle => 'طرق الدفع';

  @override
  String get paymentMethodsSubtitle =>
      'إدارة الحساب الذي تُرحَّل إليه كل طريقة دفع';

  @override
  String get backupRestoreTitle => 'النسخ الاحتياطي والاستعادة';

  @override
  String get backupRestoreSubtitle => 'حفظ أو استعادة نسخة كاملة من بياناتك';

  @override
  String get auditLogTitle => 'سجل التدقيق';

  @override
  String get auditLogSubtitle =>
      'كل عملية إضافة أو تعديل أو حذف، مع تحديد من ومتى';

  @override
  String get aboutTitle => 'حول التطبيق';

  @override
  String get addUser => 'إضافة مستخدم';

  @override
  String get editUser => 'تعديل المستخدم';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get role => 'الصلاحية';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get cancelPasswordReset => 'إلغاء إعادة التعيين';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get cannotChangeOwnRole => 'لا يمكنك تغيير صلاحيتك الخاصة.';

  @override
  String get inactiveUsersCannotSignIn =>
      'المستخدمون غير النشطين لا يمكنهم تسجيل الدخول';

  @override
  String get newPaymentMethod => 'طريقة دفع جديدة';

  @override
  String get methodName => 'اسم الطريقة';

  @override
  String get postsToAccount => 'تُرحَّل إلى حساب';

  @override
  String get createBackupTitle => 'إنشاء نسخة احتياطية';

  @override
  String get createBackupDescription =>
      'يحفظ نسخة كاملة من كل سجل في التطبيق - الإيرادات والمصروفات والأطباء والخدمات والمرضى والموردين والإعدادات - في ملف واحد يمكنك حفظه على Google Drive أو إرساله لبريدك أو نسخه إلى جهاز كمبيوتر.';

  @override
  String get createBackupButton => 'إنشاء نسخة احتياطية';

  @override
  String get restoreBackupTitle => 'الاستعادة من نسخة احتياطية';

  @override
  String get restoreBackupDescription =>
      'يستبدل كل ما هو موجود حالياً في التطبيق بمحتوى ملف النسخة الاحتياطية. استخدم هذا عند إعداد هاتف جديد، أو للتراجع عن فقدان بيانات جسيم. سترى بالضبط ما يحتويه الملف قبل استبدال أي شيء.';

  @override
  String get chooseBackupFile => 'اختر ملف النسخة الاحتياطية';

  @override
  String get backupSecurityNote =>
      'ملاحظة أمنية: يمكن لأي شخص يملك ملف النسخة الاحتياطية فتحه - فهو يحتوي على كل ما في قاعدة بياناتك. احتفظ بملفات النسخ الاحتياطي في مكان تتحكم فيه، وتجنّب إرسالها بالبريد الإلكتروني أو تركها في مجلد مشترك.';

  @override
  String get restoreConfirmTitle => 'هل تريد استعادة هذه النسخة الاحتياطية؟';

  @override
  String get restoreConfirmWarning =>
      'سيؤدي هذا إلى استبدال كل ما هو موجود حالياً في التطبيق - جميع الإيرادات والمصروفات والأطباء والخدمات والمرضى والموردين والمستخدمين. لا يمكن التراجع عن هذا إلا إذا كانت لديك نسخة احتياطية أخرى من البيانات الحالية.';

  @override
  String get restoreConfirmButton => 'استبدال كل شيء والاستعادة';

  @override
  String get recordTypeAll => 'كل السجلات';

  @override
  String get actionAll => 'كل العمليات';

  @override
  String get actionCreated => 'تمت الإضافة';

  @override
  String get actionUpdated => 'تم التعديل';

  @override
  String get actionDeleted => 'تم الحذف';

  @override
  String get noMatchingAuditEntries => 'لا توجد سجلات تدقيق مطابقة';
}
