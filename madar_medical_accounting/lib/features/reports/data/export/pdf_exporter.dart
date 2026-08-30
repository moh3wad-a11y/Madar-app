import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import 'report_table.dart';

class PdfExporter {
  PdfExporter._();

  static Future<String> export(ReportTable table) async {
    final document = pw.Document();

    final headers = table.columns.map((c) => c.header).toList();
    final dataRows = table.rows
        .map((row) => row
            .map((cell) => cell is double ? CurrencyFormatter.formatNumber(cell) : cell.toString())
            .toList())
        .toList();

    List<String>? totalsRow;
    if (table.includeTotalsRow && table.rows.isNotEmpty) {
      totalsRow = List.generate(table.columns.length, (i) {
        if (i == 0) return 'Total';
        if (table.columns[i].isNumeric) return CurrencyFormatter.formatNumber(table.columnTotal(i));
        return '';
      });
    }

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(table.title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text(
              'Generated ${DateFormatter.toDisplayDateTime(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 12),
          ],
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: dataRows,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignments: {
              for (var i = 0; i < table.columns.length; i++)
                i: table.columns[i].isNumeric ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
            },
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
          ),
          if (totalsRow != null) ...[
            pw.SizedBox(height: 4),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: const pw.BoxDecoration(
                border: pw.Border(top: pw.BorderSide(width: 1, color: PdfColors.black)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: totalsRow
                    .map((cell) => pw.Expanded(
                          child: pw.Text(
                            cell,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );

    final directory = await getTemporaryDirectory();
    final fileName = _fileName(table.title, 'pdf');
    final filePath = p.join(directory.path, fileName);
    final file = File(filePath);
    await file.writeAsBytes(await document.save());
    return filePath;
  }

  static String _fileName(String title, String extension) {
    final sanitized = title.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(RegExp(r'\s+'), '_');
    final date = DateFormatter.toStorage(DateTime.now());
    return '${sanitized}_$date.$extension';
  }
}
