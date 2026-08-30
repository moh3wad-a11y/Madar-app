import '../constants/app_constants.dart';

/// Every permission a screen or repository write might require.
/// Kept as one flat enum (rather than per-module booleans) so a single
/// AuthGuard.can() check works everywhere - in the UI to hide widgets,
/// and in repositories to reject writes even if a hidden screen is
/// somehow reached (deep link, restored state, etc).
enum Permission {
  viewDashboard,
  addRevenue,
  editRevenue,
  deleteRevenue,
  addExpense,
  editExpense,
  deleteExpense,
  manageDoctors,
  manageServices,
  managePatients,
  manageSuppliers,
  managePaymentAccounts,
  viewReports,
  exportReports,
  manageUsers,
  manageSettings,
  viewAuditLog,
  backupRestore,
}

class AuthGuard {
  AuthGuard._();

  static final Map<String, List<Permission>> _rolePermissions = {
    AppConstants.roleOwner: Permission.values,
    AppConstants.roleAccountant: [
      Permission.viewDashboard,
      Permission.addRevenue,
      Permission.editRevenue,
      Permission.deleteRevenue,
      Permission.addExpense,
      Permission.editExpense,
      Permission.deleteExpense,
      Permission.manageDoctors,
      Permission.manageServices,
      Permission.managePatients,
      Permission.manageSuppliers,
      Permission.managePaymentAccounts,
      Permission.viewReports,
      Permission.exportReports,
      Permission.backupRestore,
    ],
    AppConstants.roleReception: [
      Permission.viewDashboard,
      Permission.addRevenue,
      Permission.managePatients,
    ],
    AppConstants.roleViewer: [
      Permission.viewDashboard,
      Permission.viewReports,
      Permission.exportReports,
    ],
  };

  static bool can(String? roleName, Permission permission) {
    if (roleName == null) return false;
    final permissions = _rolePermissions[roleName];
    if (permissions == null) return false;
    return permissions.contains(permission);
  }
}
