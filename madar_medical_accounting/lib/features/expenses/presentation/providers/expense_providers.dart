import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/expense_transaction_model.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/repositories/expense_repository.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) => ExpenseRepositoryImpl());

final expenseFilterProvider = StateProvider.autoDispose<ExpenseFilter>((ref) => const ExpenseFilter());

final expenseListProvider = FutureProvider.autoDispose<List<ExpenseTransactionModel>>((ref) async {
  final filter = ref.watch(expenseFilterProvider);
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.getAll(filter);
});
