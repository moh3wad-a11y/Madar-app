class ServiceModel {
  final int? id;
  final String name;
  final String? category;
  final double price;
  final int? doctorId; // default doctor for this service, editable per transaction
  final bool isActive;
  final DateTime createdAt;

  ServiceModel({
    this.id,
    required this.name,
    this.category,
    required this.price,
    this.doctorId,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'doctor_id': doctorId,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String?,
      price: (map['price'] as num).toDouble(),
      doctorId: map['doctor_id'] as int?,
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  ServiceModel copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
    int? doctorId,
    bool clearDoctor = false,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      doctorId: clearDoctor ? null : (doctorId ?? this.doctorId),
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
