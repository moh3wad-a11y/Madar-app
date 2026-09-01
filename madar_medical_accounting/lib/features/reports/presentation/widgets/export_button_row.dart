import 'package:flutter/material.dart';
import 'package:madar_medical_accounting/l10n/generated/app_localizations.dart';
import '../../data/export/report_export_service.dart';
import '../../data/export/report_table.dart';

class ExportButtonRow extends StatefulWidget {
  final ReportTable Function() buildTable;

  const ExportButtonRow({super.key, required this.buildTable});

  @override
  State<ExportButtonRow> createState() => _ExportButtonRowState();
}

class _ExportButtonRowState extends State<ExportButtonRow> {
  bool _exporting = false;

  Future<void> _export(ExportFormat format) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      await ReportExportService.exportAndShare(widget.buildTable(), format);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.errorGeneric} ($e)')));
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_exporting) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ExportChip(label: l10n.exportExcel, icon: Icons.grid_on, onTap: () => _export(ExportFormat.excel)),
        const SizedBox(width: 8),
        _ExportChip(label: l10n.exportCsv, icon: Icons.list_alt, onTap: () => _export(ExportFormat.csv)),
        const SizedBox(width: 8),
        _ExportChip(label: l10n.exportPdf, icon: Icons.picture_as_pdf_outlined, onTap: () => _export(ExportFormat.pdf)),
      ],
    );
  }
}

class _ExportChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ExportChip({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
