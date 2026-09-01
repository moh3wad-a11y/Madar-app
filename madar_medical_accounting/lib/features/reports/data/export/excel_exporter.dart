import 'dart:io';
import 'package:excel/excel.dart' as xl;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../../core/utils/date_formatter.dart';
import 'report_table.dart';

/// Numeric columns are written as real numeric cells (xl.DoubleCellValue),
/// not text - so the exported file is genuinely usable for further
/// analysis in Excel, not just a printout. The totals row uses an actual
/// SUM() formula referencing the data range above it, rather than a
/// pre-computed hardcoded number, so it stays correct if a user edits a
/// cell after opening the file.
class ExcelExporter {
  ExcelExporter._();

  static Future<String> export(ReportTable table) async {
    final workbook = xl.Excel.createExcel();
    const sheetName = 'Report';
    final sheet = workbook[sheetName];
    // Excel.createExcel() starts with a default sheet (usually 'Sheet1').
    // Delete every sheet except the one we're building, using the sheets
    // map directly rather than a getDefaultSheet()-style helper, since
    // that method's exact name has changed across package versions.
    for (final existingName in workbook.sheets.keys.toList()) {
      if (existingName != sheetName) workbook.delete(existingName);
    }

    // Title row
    sheet.appendRow([xl.TextCellValue(table.title)]);
    sheet.appendRow([xl.TextCellValue('Generated ${DateFormatter.toDisplayDateTime(DateTime.now())}')]);
    sheet.appendRow([]);

    // Header row
    sheet.appendRow(table.columns.map((c) => xl.TextCellValue(c.header)).toList());
    final headerRowIndex = 3; // 0-indexed: title(0), generated(1), blank(2), header(3)

    // Data rows
    for (final row in table.rows) {
      sheet.appendRow(row.map((cell) {
        if (cell is double) return xl.DoubleCellValue(cell);
        if (cell is int) return xl.IntCellValue(cell);
        return xl.TextCellValue(cell.toString());
      }).toList());
    }

    // Totals row with real SUM formulas for numeric columns
    if (table.includeTotalsRow && table.rows.isNotEmpty) {
      final firstDataRow = headerRowIndex + 2; // 1-indexed Excel row of the first data row
      final lastDataRow = headerRowIndex + 1 + table.rows.length; // 1-indexed Excel row of the last data row
      final totalsRow = <xl.CellValue>[];
      for (var i = 0; i < table.columns.length; i++) {
        if (i == 0) {
          totalsRow.add(xl.TextCellValue('Total'));
        } else if (table.columns[i].isNumeric) {
          final columnLetter = _columnLetter(i);
          totalsRow.add(xl.FormulaCellValue('SUM($columnLetter$firstDataRow:$columnLetter$lastDataRow)'));
        } else {
          totalsRow.add(xl.TextCellValue(''));
        }
      }
      sheet.appendRow(totalsRow);
    }

    final bytes = workbook.save();
    if (bytes == null) {
      throw Exception('Failed to generate the Excel file');
    }

    final directory = await getTemporaryDirectory();
    final fileName = _fileName(table.title, 'xlsx');
    final filePath = p.join(directory.path, fileName);
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  static String _columnLetter(int index) {
    var result = '';
    var n = index;
    while (true) {
      result = String.fromCharCode(65 + (n % 26)) + result;
      n = (n ~/ 26) - 1;
      if (n < 0) break;
    }
    return result;
  }

  static String _fileName(String title, String extension) {
    final sanitized = title.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(RegExp(r'\s+'), '_');
    final date = DateFormatter.toStorage(DateTime.now());
    return '${sanitized}_$date.$extension';
  }
}
