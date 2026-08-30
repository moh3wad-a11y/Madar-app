import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/expense_category_model.dart';
import '../../data/repositories/expense_category_repository_impl.dart';
import '../../domain/repositories/expense_category_repository.dart';

final expenseCategoryRepositoryProvider =
    Provider<ExpenseCategoryRepository>((ref) => ExpenseCategoryRepositoryImpl());

final activeExpenseCategoriesProvider =
    FutureProvider.autoDispose<List<ExpenseCategoryModel>>((ref) async {
  final repo = ref.watch(expenseCategoryRepositoryProvider);
  return repo.getAll(activeOnly: true);
});

final allExpenseCategoriesProvider = FutureProvider.autoDispose<List<ExpenseCategoryModel>>((ref) async {
  final repo = ref.watch(expenseCategoryRepositoryProvider);
  return repo.getAll();
});
