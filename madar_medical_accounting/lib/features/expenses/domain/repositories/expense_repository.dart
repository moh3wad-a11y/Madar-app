import '../../../../core/utils/date_formatter.dart';
import '../../data/models/expense_transaction_model.dart';

class ExpenseFilter {
  final DateRange? dateRange;
  final int? categoryId;
  final int? supplierId;
  final int? paymentMethodId;
  final String? searchQuery;

  const ExpenseFilter({
    this.dateRange,
    this.categoryId,
    this.supplierId,
    this.paymentMethodId,
    this.searchQuery,
  });
}

abstract class ExpenseRepository {
  Future<List<ExpenseTransactionModel>> getAll(ExpenseFilter filter);
  Future<ExpenseTransactionModel?> getById(int id);
  Future<ExpenseTransactionModel> create(ExpenseTransactionModel expense);
  Future<void> update(ExpenseTransactionModel expense);
  Future<void> softDelete(int id, {required int userId});
}
