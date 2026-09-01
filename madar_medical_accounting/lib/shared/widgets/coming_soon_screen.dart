import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';

/// Used ONLY by modules whose screen hasn't been built yet in the current
/// delivery phase. It is not a fake or simulated feature - it says plainly
/// that the data layer (models, repository, database table) already
/// exists and works, and that this specific screen file will be replaced
/// with the real CRUD interface in the next phase of the project.
/// (Currently unreferenced - every module reached a real screen across
/// Phases 2-5 - kept for any future module built the same way.)
class ComingSoonScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const ComingSoonScreen({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: theme.colorScheme.outline),
              const SizedBox(height: 16),
              Text(l10n.comingSoonTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                l10n.comingSoonMessage,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
