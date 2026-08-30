import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import 'report_table.dart';

class CsvExporter {
  CsvExporter._();

  static Future<String> export(ReportTable table) async {
    final rows = <List<dynamic>>[
      [table.title],
      ['Generated ${DateFormatter.toDisplayDateTime(DateTime.now())}'],
      [],
      table.columns.map((c) => c.header).toList(),
      ...table.rows,
    ];

    if (table.includeTotalsRow && table.rows.isNotEmpty) {
      final totals = <dynamic>[];
      for (var i = 0; i < table.columns.length; i++) {
        if (i == 0) {
          totals.add('Total');
        } else if (table.columns[i].isNumeric) {
          totals.add(CurrencyFormatter.formatNumber(table.columnTotal(i)));
        } else {
          totals.add('');
        }
      }
      rows.add(totals);
    }

    final csvContent = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final fileName = _fileName(table.title, 'csv');
    final filePath = p.join(directory.path, fileName);
    final file = File(filePath);
    await file.writeAsString(csvContent);
    return filePath;
  }

  static String _fileName(String title, String extension) {
    final sanitized = title.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(RegExp(r'\s+'), '_');
    final date = DateFormatter.toStorage(DateTime.now());
    return '${sanitized}_$date.$extension';
  }
}
