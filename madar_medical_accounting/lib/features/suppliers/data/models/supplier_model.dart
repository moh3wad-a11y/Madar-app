class SupplierModel {
  final int? id;
  final String name;
  final String? phone;
  final String? address;
  final String? taxId;
  final String? notes;
  final DateTime createdAt;

  SupplierModel({
    this.id,
    required this.name,
    this.phone,
    this.address,
    this.taxId,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'tax_id': taxId,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SupplierModel.fromMap(Map<String, dynamic> map) {
    return SupplierModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      taxId: map['tax_id'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  SupplierModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? taxId,
    String? notes,
    DateTime? createdAt,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      taxId: taxId ?? this.taxId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
