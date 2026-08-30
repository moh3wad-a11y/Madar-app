import 'package:share_plus/share_plus.dart';
import 'csv_exporter.dart';
import 'excel_exporter.dart';
import 'pdf_exporter.dart';
import 'report_table.dart';

enum ExportFormat { excel, csv, pdf }

class ReportExportService {
  ReportExportService._();

  /// Uses the Share.shareXFiles static method deliberately, rather than
  /// the newer SharePlus.instance.share(ShareParams(...)) pattern - that
  /// API was introduced in a later share_plus major version than the one
  /// pinned in pubspec.yaml (^9.0.0), while shareXFiles has been stable
  /// across many versions and is the safer bet without a live compiler
  /// to verify against.
  static Future<void> exportAndShare(ReportTable table, ExportFormat format) async {
    final String filePath;
    switch (format) {
      case ExportFormat.excel:
        filePath = await ExcelExporter.export(table);
        break;
      case ExportFormat.csv:
        filePath = await CsvExporter.export(table);
        break;
      case ExportFormat.pdf:
        filePath = await PdfExporter.export(table);
        break;
    }
    await Share.shareXFiles([XFile(filePath)], subject: table.title);
  }
}
