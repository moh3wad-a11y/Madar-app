import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/revenue/presentation/screens/revenue_list_screen.dart';
import '../../features/expenses/presentation/screens/expense_list_screen.dart';
import '../../features/reports/presentation/screens/reports_hub_screen.dart';
import '../../features/settings/presentation/screens/more_screen.dart';

/// The 5 bottom-nav destinations. Doctors/Services/Patients/Suppliers/
/// Payment accounts/Settings live inside "More" rather than getting their
/// own bottom-nav slots - Material guidelines cap bottom nav at 5 items,
/// and a receptionist-usable app shouldn't have to hunt through 9 flat
/// tabs (see the architecture note on this).
class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    DashboardScreen(),
    RevenueListScreen(),
    ExpenseListScreen(),
    ReportsHubScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.payments_outlined),
            selectedIcon: const Icon(Icons.payments),
            label: l10n.navRevenue,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.navExpenses,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l10n.navReports,
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(Icons.grid_view),
            label: l10n.navMore,
          ),
        ],
      ),
    );
  }
}
