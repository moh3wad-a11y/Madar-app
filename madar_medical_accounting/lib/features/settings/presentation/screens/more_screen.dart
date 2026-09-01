import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import '../../../../core/security/auth_guard.dart';
import '../../../../shared/widgets/role_gate.dart';
import '../../../doctors/presentation/screens/doctor_list_screen.dart';
import '../../../patients/presentation/screens/patient_list_screen.dart';
import '../../../payment_accounts/presentation/screens/payment_accounts_screen.dart';
import '../../../services/presentation/screens/service_list_screen.dart';
import '../../../suppliers/presentation/screens/supplier_list_screen.dart';
import 'settings_hub_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tiles = <_MoreTile>[
      _MoreTile(
        l10n.navDoctors,
        Icons.medical_services_outlined,
        Permission.manageDoctors,
        builder: (_) => const DoctorListScreen(),
      ),
      _MoreTile(
        l10n.navServices,
        Icons.medical_information_outlined,
        Permission.manageServices,
        builder: (_) => const ServiceListScreen(),
      ),
      _MoreTile(
        l10n.navPatients,
        Icons.people_outline,
        Permission.managePatients,
        builder: (_) => const PatientListScreen(),
      ),
      _MoreTile(
        l10n.navSuppliers,
        Icons.local_shipping_outlined,
        Permission.manageSuppliers,
        builder: (_) => const SupplierListScreen(),
      ),
      _MoreTile(
        l10n.navPaymentAccounts,
        Icons.account_balance_wallet_outlined,
        Permission.managePaymentAccounts,
        builder: (_) => const PaymentAccountsScreen(),
      ),
      _MoreTile(
        l10n.navSettings,
        Icons.settings_outlined,
        Permission.manageSettings,
        fallbackVisible: true,
        builder: (_) => const SettingsHubScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navMore)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
        ),
        itemCount: tiles.length,
        itemBuilder: (context, index) {
          final tile = tiles[index];
          final card = _MoreTileCard(tile: tile);
          // Settings is visible to everyone (even a Viewer can see About/app
          // info once that screen is real), everything else respects the
          // permission matrix.
          if (tile.fallbackVisible) return card;
          return RoleGate(permission: tile.permission, child: card);
        },
      ),
    );
  }
}

class _MoreTile {
  final String label;
  final IconData icon;
  final Permission permission;
  final WidgetBuilder builder;
  final bool fallbackVisible;

  const _MoreTile(
    this.label,
    this.icon,
    this.permission, {
    required this.builder,
    this.fallbackVisible = false,
  });
}

class _MoreTileCard extends StatelessWidget {
  final _MoreTile tile;

  const _MoreTileCard({required this.tile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: tile.builder));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tile.icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(tile.label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
