import '../../data/models/expense_category_model.dart';

abstract class ExpenseCategoryRepository {
  Future<List<ExpenseCategoryModel>> getAll({bool activeOnly = false});
  Future<ExpenseCategoryModel> create(ExpenseCategoryModel category, {required int userId});
  Future<void> update(ExpenseCategoryModel category, {required int userId});
  Future<void> setActive(int id, bool isActive, {required int userId});
}
