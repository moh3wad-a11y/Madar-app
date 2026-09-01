import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/restart_widget.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/backup_service.dart';
import '../../data/restore_service.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final _backupService = BackupService();
  final _restoreService = RestoreService();
  bool _working = false;

  Future<void> _createBackup() async {
    setState(() => _working = true);
    try {
      final path = await _backupService.createBackup();
      await Share.shareXFiles([XFile(path)], subject: 'Madar Medical Center Accounting - Backup');
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.errorGeneric} ($e)')));
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _pickAndRestore() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    final path = result?.files.single.path;
    if (path == null) return;

    setState(() => _working = true);
    BackupMetadata metadata;
    try {
      metadata = await _restoreService.inspectBackup(path);
    } catch (e) {
      if (mounted) {
        setState(() => _working = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.errorGeneric} ($e)')));
      }
      return;
    }
    setState(() => _working = false);

    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restoreConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormatter.toDisplayDateTime(metadata.backupDate)),
            const SizedBox(height: 8),
            Text(l10n.total, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            ...metadata.recordCounts.entries.map((e) => Text('  ${_friendlyTableName(l10n, e.key)}: ${e.value}')),
            const SizedBox(height: 12),
            Text(
              l10n.restoreConfirmWarning,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.restoreConfirmButton),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _working = true);
    try {
      await _restoreService.restoreFromBackup(path);
      if (mounted) RestartWidget.restartApp(context);
    } catch (e) {
      if (mounted) {
        setState(() => _working = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.errorGeneric} ($e)')));
      }
    }
  }

  String _friendlyTableName(AppLocalizations l10n, String table) {
    switch (table) {
      case 'revenue_transactions':
        return l10n.navRevenue;
      case 'expense_transactions':
        return l10n.navExpenses;
      case 'doctors':
        return l10n.navDoctors;
      case 'services':
        return l10n.navServices;
      case 'patients':
        return l10n.navPatients;
      case 'suppliers':
        return l10n.navSuppliers;
      case 'users':
        return l10n.usersTitle;
      default:
        return table;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupRestoreTitle)),
      body: _working
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.backup_outlined, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(l10n.createBackupTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(l10n.createBackupDescription),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _createBackup,
                          icon: const Icon(Icons.save_alt),
                          label: Text(l10n.createBackupButton),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.restore_outlined, color: theme.colorScheme.error),
                            const SizedBox(width: 8),
                            Text(l10n.restoreBackupTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(l10n.restoreBackupDescription),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _pickAndRestore,
                          icon: const Icon(Icons.file_open_outlined),
                          label: Text(l10n.chooseBackupFile),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    l10n.backupSecurityNote,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                  ),
                ),
              ],
            ),
    );
  }
}
