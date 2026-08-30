import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.local_hospital_rounded, color: theme.colorScheme.onPrimaryContainer, size: 36),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.appTitle, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Version 1.0.0', style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          const Text(
            'An offline, bilingual accounting app for medical centers - revenue, expenses, doctor commissions, '
            'cash flow, and reporting, all stored locally and encrypted on this device.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
