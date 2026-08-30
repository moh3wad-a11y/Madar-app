import '../../data/models/supplier_model.dart';

abstract class SupplierRepository {
  Future<List<SupplierModel>> getAll({String? searchQuery});
  Future<SupplierModel?> getById(int id);
  Future<SupplierModel> create(SupplierModel supplier, {required int userId});
  Future<void> update(SupplierModel supplier, {required int userId});
}
