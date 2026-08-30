class ExpenseCategoryModel {
  final int? id;
  final String name;
  final String? nameAr;
  final bool isActive;

  ExpenseCategoryModel({
    this.id,
    required this.name,
    this.nameAr,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory ExpenseCategoryModel.fromMap(Map<String, dynamic> map) {
    return ExpenseCategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      nameAr: map['name_ar'] as String?,
      isActive: (map['is_active'] as int) == 1,
    );
  }

  ExpenseCategoryModel copyWith({int? id, String? name, String? nameAr, bool? isActive}) {
    return ExpenseCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      isActive: isActive ?? this.isActive,
    );
  }
}
