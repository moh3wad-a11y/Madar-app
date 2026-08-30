import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/auth_guard.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Wraps a widget (an "Add" FAB, an "Edit" button, a whole nav destination)
/// and only renders it if the signed-in user's role has [permission].
/// This is the UI half of role enforcement - the repository layer is the
/// other half, so a hidden action can never be reached by another route
/// and still succeed.
class RoleGate extends ConsumerWidget {
  final Permission permission;
  final Widget child;
  final Widget? fallback;

  const RoleGate({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleName = ref.watch(authProvider).currentUser?.roleName;
    final allowed = AuthGuard.can(roleName, permission);
    if (allowed) return child;
    return fallback ?? const SizedBox.shrink();
  }
}
