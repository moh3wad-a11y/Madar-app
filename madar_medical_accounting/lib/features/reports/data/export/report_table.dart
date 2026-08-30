/// A column in an exportable report. Numeric columns get summed into an
/// automatic totals row (as a real Excel SUM formula in the .xlsx export,
/// and as a computed sum in CSV/PDF).
class ReportColumn {
  final String header;
  final bool isNumeric;
  const ReportColumn(this.header, {this.isNumeric = false});
}

/// Generic exportable report: a title, typed columns, and rows where each
/// cell is either a String (text columns) or a double (numeric columns -
/// callers must match cell types to column.isNumeric).
class ReportTable {
  final String title;
  final List<ReportColumn> columns;
  final List<List<Object>> rows;
  final bool includeTotalsRow;

  const ReportTable({
    required this.title,
    required this.columns,
    required this.rows,
    this.includeTotalsRow = true,
  });

  double columnTotal(int columnIndex) {
    double total = 0;
    for (final row in rows) {
      final value = row[columnIndex];
      if (value is double) total += value;
      if (value is int) total += value.toDouble();
    }
    return total;
  }
}
