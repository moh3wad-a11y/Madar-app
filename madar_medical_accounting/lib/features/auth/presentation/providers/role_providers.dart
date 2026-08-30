import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';

class RoleOption {
  final int id;
  final String name;
  const RoleOption(this.id, this.name);
}

final rolesProvider = FutureProvider.autoDispose<List<RoleOption>>((ref) async {
  final db = await DatabaseHelper.instance.database;
  final rows = await db.query('roles', orderBy: 'id');
  return rows.map((r) => RoleOption(r['id'] as int, r['name'] as String)).toList();
});
