class ExpenseTransactionModel {
  final int? id;
  final String expenseNo;
  final DateTime date;
  final int categoryId;
  final int? supplierId;
  final String? description;
  final double amount;
  final int paymentMethodId;
  final String? invoiceNumber;
  final String? attachmentPath;
  final String? notes;
  final bool isDeleted;
  final int createdBy;
  final DateTime createdAt;
  final int? modifiedBy;
  final DateTime? modifiedAt;

  // Joined display fields, populated by repository reads only.
  final String? categoryName;
  final String? supplierName;
  final String? paymentMethodName;

  ExpenseTransactionModel({
    this.id,
    required this.expenseNo,
    required this.date,
    required this.categoryId,
    this.supplierId,
    this.description,
    required this.amount,
    required this.paymentMethodId,
    this.invoiceNumber,
    this.attachmentPath,
    this.notes,
    this.isDeleted = false,
    required this.createdBy,
    required this.createdAt,
    this.modifiedBy,
    this.modifiedAt,
    this.categoryName,
    this.supplierName,
    this.paymentMethodName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expense_no': expenseNo,
      'date': date.toIso8601String().split('T').first,
      'category_id': categoryId,
      'supplier_id': supplierId,
      'description': description,
      'amount': amount,
      'payment_method_id': paymentMethodId,
      'invoice_number': invoiceNumber,
      'attachment_path': attachmentPath,
      'notes': notes,
      'is_deleted': isDeleted ? 1 : 0,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'modified_by': modifiedBy,
      'modified_at': modifiedAt?.toIso8601String(),
    };
  }

  factory ExpenseTransactionModel.fromMap(Map<String, dynamic> map) {
    return ExpenseTransactionModel(
      id: map['id'] as int?,
      expenseNo: map['expense_no'] as String,
      date: DateTime.parse(map['date'] as String),
      categoryId: map['category_id'] as int,
      supplierId: map['supplier_id'] as int?,
      description: map['description'] as String?,
      amount: (map['amount'] as num).toDouble(),
      paymentMethodId: map['payment_method_id'] as int,
      invoiceNumber: map['invoice_number'] as String?,
      attachmentPath: map['attachment_path'] as String?,
      notes: map['notes'] as String?,
      isDeleted: (map['is_deleted'] as int) == 1,
      createdBy: map['created_by'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      modifiedBy: map['modified_by'] as int?,
      modifiedAt: map['modified_at'] != null ? DateTime.parse(map['modified_at'] as String) : null,
      categoryName: map['category_name'] as String?,
      supplierName: map['supplier_name'] as String?,
      paymentMethodName: map['payment_method_name'] as String?,
    );
  }

  ExpenseTransactionModel copyWith({
    int? id,
    String? expenseNo,
    DateTime? date,
    int? categoryId,
    int? supplierId,
    bool clearSupplier = false,
    String? description,
    double? amount,
    int? paymentMethodId,
    String? invoiceNumber,
    String? attachmentPath,
    String? notes,
    bool? isDeleted,
    int? createdBy,
    DateTime? createdAt,
    int? modifiedBy,
    DateTime? modifiedAt,
  }) {
    return ExpenseTransactionModel(
      id: id ?? this.id,
      expenseNo: expenseNo ?? this.expenseNo,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      supplierId: clearSupplier ? null : (supplierId ?? this.supplierId),
      description: description ?? this.description,
      amount: amount ?? this.amount,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      notes: notes ?? this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      categoryName: categoryName,
      supplierName: supplierName,
      paymentMethodName: paymentMethodName,
    );
  }
}
