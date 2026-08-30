class DoctorModel {
  final int? id;
  final String name;
  final String? specialty;
  final String? phone;
  final String commissionType; // 'percentage' | 'fixed' | 'none'
  final double commissionValue; // percent (0-100) if percentage, EGP if fixed
  final bool isActive;
  final DateTime createdAt;

  DoctorModel({
    this.id,
    required this.name,
    this.specialty,
    this.phone,
    required this.commissionType,
    required this.commissionValue,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'phone': phone,
      'commission_type': commissionType,
      'commission_value': commissionValue,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      specialty: map['specialty'] as String?,
      phone: map['phone'] as String?,
      commissionType: map['commission_type'] as String,
      commissionValue: (map['commission_value'] as num).toDouble(),
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  DoctorModel copyWith({
    int? id,
    String? name,
    String? specialty,
    String? phone,
    String? commissionType,
    double? commissionValue,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      phone: phone ?? this.phone,
      commissionType: commissionType ?? this.commissionType,
      commissionValue: commissionValue ?? this.commissionValue,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Computes (doctorCommission, centerShare) for a given net revenue amount,
  /// per section 6/24 of the spec. Commission is calculated on NET revenue
  /// (post-discount) - the cash actually recognized by the center.
  (double commission, double centerShare) computeSplit(double netAmount) {
    double commission;
    switch (commissionType) {
      case 'percentage':
        commission = netAmount * (commissionValue / 100);
        break;
      case 'fixed':
        commission = commissionValue;
        break;
      default:
        commission = 0;
    }
    if (commission > netAmount) commission = netAmount; // never exceed the transaction itself
    final centerShare = netAmount - commission;
    return (commission, centerShare);
  }
}
