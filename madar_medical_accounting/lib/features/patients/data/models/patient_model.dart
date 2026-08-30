class PatientModel {
  final int? id;
  final String name;
  final String? phone;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? notes;
  final DateTime createdAt;

  PatientModel({
    this.id,
    required this.name,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      gender: map['gender'] as String?,
      dateOfBirth: map['date_of_birth'] != null ? DateTime.parse(map['date_of_birth'] as String) : null,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  PatientModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? gender,
    DateTime? dateOfBirth,
    bool clearDateOfBirth = false,
    String? notes,
    DateTime? createdAt,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: clearDateOfBirth ? null : (dateOfBirth ?? this.dateOfBirth),
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
