import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../../../audit/presentation/screens/audit_log_screen.dart';
import '../../../auth/presentation/screens/user_management_screen.dart';
import '../../../backup/presentation/screens/backup_restore_screen.dart';
import 'about_screen.dart';
import 'payment_methods_screen.dart';

class SettingsHubScreen extends StatelessWidget {
  const SettingsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          RoleGate(
            permission: Permission.manageUsers,
            child: ListTile(
              leading: const Icon(Icons.people_outline),
              title: Text(l10n.usersTitle),
              subtitle: Text(l10n.usersSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const UserManagementScreen())),
            ),
          ),
          RoleGate(
            permission: Permission.managePaymentAccounts,
            child: ListTile(
              leading: const Icon(Icons.credit_card_outlined),
              title: Text(l10n.paymentMethodsTitle),
              subtitle: Text(l10n.paymentMethodsSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const PaymentMethodsScreen())),
            ),
          ),
          RoleGate(
            permission: Permission.backupRestore,
            child: ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: Text(l10n.backupRestoreTitle),
              subtitle: Text(l10n.backupRestoreSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const BackupRestoreScreen())),
            ),
          ),
          RoleGate(
            permission: Permission.viewAuditLog,
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text(l10n.auditLogTitle),
              subtitle: Text(l10n.auditLogSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuditLogScreen())),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutScreen())),
          ),
        ],
      ),
    );
  }
}
