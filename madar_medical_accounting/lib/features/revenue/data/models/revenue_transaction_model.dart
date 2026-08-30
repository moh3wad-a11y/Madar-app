class RevenueTransactionModel {
  final int? id;
  final String transactionNo;
  final DateTime date;
  final String time; // HH:mm, stored separately from date per spec section 4
  final int? patientId;
  final int doctorId;
  final int serviceId;
  final double grossAmount;
  final double discount;
  final double netAmount; // grossAmount - discount
  final int paymentMethodId;
  final double doctorCommissionAmount;
  final double centerShareAmount;
  final String? notes;
  final bool isDeleted;
  final int createdBy;
  final DateTime createdAt;
  final int? modifiedBy;
  final DateTime? modifiedAt;

  // Joined display fields - populated by the repository's read queries,
  // never written back to the DB.
  final String? patientName;
  final String? doctorName;
  final String? serviceName;
  final String? paymentMethodName;

  RevenueTransactionModel({
    this.id,
    required this.transactionNo,
    required this.date,
    required this.time,
    this.patientId,
    required this.doctorId,
    required this.serviceId,
    required this.grossAmount,
    required this.discount,
    required this.netAmount,
    required this.paymentMethodId,
    required this.doctorCommissionAmount,
    required this.centerShareAmount,
    this.notes,
    this.isDeleted = false,
    required this.createdBy,
    required this.createdAt,
    this.modifiedBy,
    this.modifiedAt,
    this.patientName,
    this.doctorName,
    this.serviceName,
    this.paymentMethodName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transaction_no': transactionNo,
      'date': date.toIso8601String().split('T').first,
      'time': time,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'service_id': serviceId,
      'gross_amount': grossAmount,
      'discount': discount,
      'net_amount': netAmount,
      'payment_method_id': paymentMethodId,
      'doctor_commission_amount': doctorCommissionAmount,
      'center_share_amount': centerShareAmount,
      'notes': notes,
      'is_deleted': isDeleted ? 1 : 0,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'modified_by': modifiedBy,
      'modified_at': modifiedAt?.toIso8601String(),
    };
  }

  factory RevenueTransactionModel.fromMap(Map<String, dynamic> map) {
    return RevenueTransactionModel(
      id: map['id'] as int?,
      transactionNo: map['transaction_no'] as String,
      date: DateTime.parse(map['date'] as String),
      time: map['time'] as String,
      patientId: map['patient_id'] as int?,
      doctorId: map['doctor_id'] as int,
      serviceId: map['service_id'] as int,
      grossAmount: (map['gross_amount'] as num).toDouble(),
      discount: (map['discount'] as num).toDouble(),
      netAmount: (map['net_amount'] as num).toDouble(),
      paymentMethodId: map['payment_method_id'] as int,
      doctorCommissionAmount: (map['doctor_commission_amount'] as num).toDouble(),
      centerShareAmount: (map['center_share_amount'] as num).toDouble(),
      notes: map['notes'] as String?,
      isDeleted: (map['is_deleted'] as int) == 1,
      createdBy: map['created_by'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      modifiedBy: map['modified_by'] as int?,
      modifiedAt: map['modified_at'] != null ? DateTime.parse(map['modified_at'] as String) : null,
      patientName: map['patient_name'] as String?,
      doctorName: map['doctor_name'] as String?,
      serviceName: map['service_name'] as String?,
      paymentMethodName: map['payment_method_name'] as String?,
    );
  }

  RevenueTransactionModel copyWith({
    int? id,
    String? transactionNo,
    DateTime? date,
    String? time,
    int? patientId,
    bool clearPatient = false,
    int? doctorId,
    int? serviceId,
    double? grossAmount,
    double? discount,
    double? netAmount,
    int? paymentMethodId,
    double? doctorCommissionAmount,
    double? centerShareAmount,
    String? notes,
    bool? isDeleted,
    int? createdBy,
    DateTime? createdAt,
    int? modifiedBy,
    DateTime? modifiedAt,
  }) {
    return RevenueTransactionModel(
      id: id ?? this.id,
      transactionNo: transactionNo ?? this.transactionNo,
      date: date ?? this.date,
      time: time ?? this.time,
      patientId: clearPatient ? null : (patientId ?? this.patientId),
      doctorId: doctorId ?? this.doctorId,
      serviceId: serviceId ?? this.serviceId,
      grossAmount: grossAmount ?? this.grossAmount,
      discount: discount ?? this.discount,
      netAmount: netAmount ?? this.netAmount,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      doctorCommissionAmount: doctorCommissionAmount ?? this.doctorCommissionAmount,
      centerShareAmount: centerShareAmount ?? this.centerShareAmount,
      notes: notes ?? this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      patientName: patientName,
      doctorName: doctorName,
      serviceName: serviceName,
      paymentMethodName: paymentMethodName,
    );
  }
}
