class UserModel {
  final int? id;
  final String username;
  final String passwordHash;
  final String salt;
  final String fullName;
  final int roleId;
  final String roleName; // joined from roles table, not a physical column
  final bool isActive;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.salt,
    required this.fullName,
    required this.roleId,
    required this.roleName,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password_hash': passwordHash,
      'salt': salt,
      'full_name': fullName,
      'role_id': roleId,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String roleName = ''}) {
    return UserModel(
      id: map['id'] as int?,
      username: map['username'] as String,
      passwordHash: map['password_hash'] as String,
      salt: map['salt'] as String,
      fullName: map['full_name'] as String,
      roleId: map['role_id'] as int,
      roleName: roleName.isNotEmpty ? roleName : (map['role_name'] as String? ?? ''),
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? passwordHash,
    String? salt,
    String? fullName,
    int? roleId,
    String? roleName,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      fullName: fullName ?? this.fullName,
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
